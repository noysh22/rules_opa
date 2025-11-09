"""Bzlmod module extensions that are only used internally"""

load("//opa/private:opa_rules_dependencies.bzl", "DEFAULT_VERSION", "opa_rules_dependencies")

_version_tag = tag_class(
    attrs = {
        "version": attr.string(
            doc = "OPA version (e.g. '1.1.0'). Defaults to DEFAULT_VERSION if not specified.",
            default = "",
        ),
    },
)

def _internal_deps_impl(module_ctx):
    # Collect version from all modules
    version = DEFAULT_VERSION
    seen_versions = []

    for module in module_ctx.modules:
        for tag in module.tags.version:
            if tag.version:
                seen_versions.append(tag.version)

    # Fail if multiple distinct versions specified
    unique_versions = {v: None for v in seen_versions}.keys()
    if len(unique_versions) > 1:
        fail("rules_opa: multiple OPA versions specified: %s. Only one version allowed." % list(unique_versions))

    # Use specified version if provided
    if seen_versions:
        version = seen_versions[-1]

    return module_ctx.extension_metadata(
        root_module_direct_deps = opa_rules_dependencies(version = version),
        root_module_direct_dev_deps = [],
    )

internal_deps = module_extension(
    doc = "Dependencies for rules_opa",
    implementation = _internal_deps_impl,
    tag_classes = {"version": _version_tag},
)
