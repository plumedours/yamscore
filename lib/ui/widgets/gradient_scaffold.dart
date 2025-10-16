import 'package:flutter/material.dart';
import '../app_theme.dart';

/// Scaffold avec fond dégradé + AppBar gradient + SafeArea en bas.
/// Empêche le contenu d'être masqué par la barre de navigation système.
class GradientScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final Color? overrideGradientTopColor;
  final Color? overrideGradientBottomColor;

  const GradientScaffold({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.overrideGradientTopColor,
    this.overrideGradientBottomColor,
  });

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final scaffoldGrad = AppTheme.scaffoldGradient(b);
    final appBarGrad = AppTheme.appBarGradient(b);

    // On enveloppe le body dans un SafeArea (top: false car AppBar gère le haut)
    final safeBody = SafeArea(
      top: false,
      bottom: true,
      left: true,
      right: true,
      minimum: const EdgeInsets.only(
        bottom: 8,
      ), // petit souffle au-dessus de la nav bar
      child: body ?? const SizedBox.shrink(),
    );

    // Idem pour une éventuelle bottomNavigationBar
    Widget? safeBottomBar;
    if (bottomNavigationBar != null) {
      safeBottomBar = SafeArea(
        top: false,
        bottom: true,
        left: true,
        right: true,
        child: bottomNavigationBar!,
      );
    }

    return Stack(
      children: [
        // Fond dégradé plein écran
        Container(
          decoration: BoxDecoration(
            gradient:
                (overrideGradientTopColor != null &&
                    overrideGradientBottomColor != null)
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      overrideGradientTopColor!,
                      overrideGradientBottomColor!,
                    ],
                  )
                : scaffoldGrad,
          ),
        ),
        // Scaffold transparent par-dessus
        Scaffold(
          backgroundColor: Colors.transparent,
          // important pour que le clavier remonte correctement
          resizeToAvoidBottomInset: true,
          appBar: (appBar == null)
              ? null
              : _GradientAppBar(
                  gradient: appBarGrad,
                  bottomBorderColor: AppTheme.appBarBottomBorder(b),
                  child: appBar!,
                ),
          body: safeBody,
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
          bottomNavigationBar: safeBottomBar,
          drawer: drawer,
          endDrawer: endDrawer,
        ),
      ],
    );
  }
}

class _GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final PreferredSizeWidget child;
  final Gradient gradient;
  final Color bottomBorderColor;

  const _GradientAppBar({
    required this.child,
    required this.gradient,
    required this.bottomBorderColor,
  });

  @override
  Size get preferredSize => child.preferredSize;

  @override
  Widget build(BuildContext context) {
    if (child is! AppBar) {
      // Fallback simple si ce n’est pas une AppBar
      return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: gradient,
            border: Border(
              bottom: BorderSide(color: bottomBorderColor, width: 1),
            ),
          ),
        ),
      );
    }

    final src = child as AppBar;
    return AppBar(
      automaticallyImplyLeading: src.automaticallyImplyLeading,
      title: src.title,
      actions: src.actions,
      leading: src.leading,
      centerTitle: src.centerTitle,
      backgroundColor: Colors.transparent,
      foregroundColor: src.foregroundColor,
      elevation: 0,
      toolbarHeight: src.toolbarHeight,
      titleSpacing: src.titleSpacing,
      bottom: src.bottom,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          border: Border(
            bottom: BorderSide(color: bottomBorderColor, width: 1),
          ),
        ),
      ),
    );
  }
}
