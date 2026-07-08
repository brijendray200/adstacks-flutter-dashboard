enum DashboardBreakpoint { mobile, tablet, desktop }

class ResponsiveLayout {
  const ResponsiveLayout._();

  static DashboardBreakpoint breakpointFor(double width) {
    if (width >= 1200) return DashboardBreakpoint.desktop;
    if (width >= 800) return DashboardBreakpoint.tablet;
    return DashboardBreakpoint.mobile;
  }
}
