"""Public bzlmod extensions for rules_opa"""

load("//opa/private:extensions.bzl", "internal_deps")

# Public alias for cleaner API
opa = internal_deps
