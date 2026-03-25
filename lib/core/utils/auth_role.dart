/// Roles allowed to use this mobile app (aligned with Laravel API contract).
const Set<String> kSupportedAppRoles = {'subscriber', 'lineman'};

/// Normalizes API role strings for comparison (trim + lowercase).
String normalizeRole(String? raw) =>
    (raw ?? '').toString().trim().toLowerCase();

bool isSupportedAppRole(String role) =>
    kSupportedAppRoles.contains(normalizeRole(role));

/// Dashboard route for [role], or `null` if this app does not support the role.
String? dashboardRouteForRole(String role) {
  final r = normalizeRole(role);
  if (r == 'subscriber') return '/subscriber/dashboard';
  if (r == 'lineman') return '/lineman/dashboard';
  return null;
}
