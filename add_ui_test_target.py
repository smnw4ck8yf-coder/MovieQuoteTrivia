from pathlib import Path
import sys

project_path = Path("MovieQuoteTrivia.xcodeproj/project.pbxproj")
text = project_path.read_text()

ids = {
    "APP_TARGET": "1A75C1E42FCE167100A00802",
    "PROJECT": "1A75C1DD2FCE167100A00802",
    "MAIN_GROUP": "1A75C1DC2FCE167100A00802",
    "PRODUCTS_GROUP": "1A75C1E62FCE167100A00802",
    "TEST_PRODUCT": "1A75C2012FCE167100A00802",
    "TEST_GROUP": "1A75C2022FCE167100A00802",
    "TEST_FRAMEWORKS": "1A75C2032FCE167100A00802",
    "TEST_RESOURCES": "1A75C2042FCE167100A00802",
    "TEST_SOURCES": "1A75C2052FCE167100A00802",
    "TEST_TARGET": "1A75C2062FCE167100A00802",
    "TEST_DEBUG": "1A75C2072FCE167100A00802",
    "TEST_RELEASE": "1A75C2082FCE167100A00802",
    "TEST_CONFIG_LIST": "1A75C2092FCE167100A00802",
    "TEST_PROXY": "1A75C20A2FCE167100A00802",
    "TEST_DEPENDENCY": "1A75C20B2FCE167100A00802",
}

for name, value in ids.items():
    if name not in {"APP_TARGET", "PROJECT", "MAIN_GROUP", "PRODUCTS_GROUP"} and value in text:
        raise SystemExit(f"Refusing to reuse existing id: {value}")

def replace_once(haystack: str, needle: str, replacement: str) -> str:
    count = haystack.count(needle)
    if count != 1:
        raise SystemExit(f"Expected exactly one match, found {count}: {needle[:80]!r}")
    return haystack.replace(needle, replacement, 1)

container_proxy = f'''/* Begin PBXContainerItemProxy section */
\t\t{ids["TEST_PROXY"]} /* PBXContainerItemProxy */ = {{
\t\t\tisa = PBXContainerItemProxy;
\t\t\tcontainerPortal = {ids["PROJECT"]} /* Project object */;
\t\t\tproxyType = 1;
\t\t\tremoteGlobalIDString = {ids["APP_TARGET"]};
\t\t\tremoteInfo = MovieQuoteTrivia;
\t\t}};
/* End PBXContainerItemProxy section */

'''

text = replace_once(
    text,
    "/* Begin PBXFileReference section */",
    container_proxy + "/* Begin PBXFileReference section */",
)

text = replace_once(
    text,
    "\t\t1A75C1E52FCE167100A00802 /* MovieQuoteTrivia.app */ = {isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = MovieQuoteTrivia.app; sourceTree = BUILT_PRODUCTS_DIR; };\n",
    "\t\t1A75C1E52FCE167100A00802 /* MovieQuoteTrivia.app */ = {isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = MovieQuoteTrivia.app; sourceTree = BUILT_PRODUCTS_DIR; };\n"
    f"\t\t{ids['TEST_PRODUCT']} /* MovieQuoteTriviaUITests.xctest */ = {{isa = PBXFileReference; explicitFileType = wrapper.cfbundle; includeInIndex = 0; path = MovieQuoteTriviaUITests.xctest; sourceTree = BUILT_PRODUCTS_DIR; }};\n",
)

text = replace_once(
    text,
    "\t\t1A75C1E72FCE167100A00802 /* MovieQuoteTrivia */ = {\n\t\t\tisa = PBXFileSystemSynchronizedRootGroup;\n\t\t\tpath = MovieQuoteTrivia;\n\t\t\tsourceTree = \"<group>\";\n\t\t};\n",
    "\t\t1A75C1E72FCE167100A00802 /* MovieQuoteTrivia */ = {\n\t\t\tisa = PBXFileSystemSynchronizedRootGroup;\n\t\t\tpath = MovieQuoteTrivia;\n\t\t\tsourceTree = \"<group>\";\n\t\t};\n"
    f"\t\t{ids['TEST_GROUP']} /* MovieQuoteTriviaUITests */ = {{\n\t\t\tisa = PBXFileSystemSynchronizedRootGroup;\n\t\t\tpath = MovieQuoteTriviaUITests;\n\t\t\tsourceTree = \"<group>\";\n\t\t}};\n",
)

text = replace_once(
    text,
    "\t\t1A75C1E22FCE167100A00802 /* Frameworks */ = {\n\t\t\tisa = PBXFrameworksBuildPhase;\n\t\t\tbuildActionMask = 2147483647;\n\t\t\tfiles = (\n\t\t\t);\n\t\t\trunOnlyForDeploymentPostprocessing = 0;\n\t\t};\n",
    "\t\t1A75C1E22FCE167100A00802 /* Frameworks */ = {\n\t\t\tisa = PBXFrameworksBuildPhase;\n\t\t\tbuildActionMask = 2147483647;\n\t\t\tfiles = (\n\t\t\t);\n\t\t\trunOnlyForDeploymentPostprocessing = 0;\n\t\t};\n"
    f"\t\t{ids['TEST_FRAMEWORKS']} /* Frameworks */ = {{\n\t\t\tisa = PBXFrameworksBuildPhase;\n\t\t\tbuildActionMask = 2147483647;\n\t\t\tfiles = (\n\t\t\t);\n\t\t\trunOnlyForDeploymentPostprocessing = 0;\n\t\t}};\n",
)

text = replace_once(
    text,
    "\t\t\tchildren = (\n\t\t\t\t1A75C1E72FCE167100A00802 /* MovieQuoteTrivia */,\n\t\t\t\t1A75C1E62FCE167100A00802 /* Products */,\n\t\t\t);\n",
    f"\t\t\tchildren = (\n\t\t\t\t1A75C1E72FCE167100A00802 /* MovieQuoteTrivia */,\n\t\t\t\t{ids['TEST_GROUP']} /* MovieQuoteTriviaUITests */,\n\t\t\t\t1A75C1E62FCE167100A00802 /* Products */,\n\t\t\t);\n",
)

text = replace_once(
    text,
    "\t\t\tchildren = (\n\t\t\t\t1A75C1E52FCE167100A00802 /* MovieQuoteTrivia.app */,\n\t\t\t);\n",
    f"\t\t\tchildren = (\n\t\t\t\t1A75C1E52FCE167100A00802 /* MovieQuoteTrivia.app */,\n\t\t\t\t{ids['TEST_PRODUCT']} /* MovieQuoteTriviaUITests.xctest */,\n\t\t\t);\n",
)

native_target = f'''\t\t{ids["TEST_TARGET"]} /* MovieQuoteTriviaUITests */ = {{
\t\t\tisa = PBXNativeTarget;
\t\t\tbuildConfigurationList = {ids["TEST_CONFIG_LIST"]} /* Build configuration list for PBXNativeTarget "MovieQuoteTriviaUITests" */;
\t\t\tbuildPhases = (
\t\t\t\t{ids["TEST_SOURCES"]} /* Sources */,
\t\t\t\t{ids["TEST_FRAMEWORKS"]} /* Frameworks */,
\t\t\t\t{ids["TEST_RESOURCES"]} /* Resources */,
\t\t\t);
\t\t\tbuildRules = (
\t\t\t);
\t\t\tdependencies = (
\t\t\t\t{ids["TEST_DEPENDENCY"]} /* PBXTargetDependency */,
\t\t\t);
\t\t\tfileSystemSynchronizedGroups = (
\t\t\t\t{ids["TEST_GROUP"]} /* MovieQuoteTriviaUITests */,
\t\t\t);
\t\t\tname = MovieQuoteTriviaUITests;
\t\t\tpackageProductDependencies = (
\t\t\t);
\t\t\tproductName = MovieQuoteTriviaUITests;
\t\t\tproductReference = {ids["TEST_PRODUCT"]} /* MovieQuoteTriviaUITests.xctest */;
\t\t\tproductType = "com.apple.product-type.bundle.ui-testing";
\t\t}};
'''

text = replace_once(
    text,
    "/* End PBXNativeTarget section */",
    native_target + "/* End PBXNativeTarget section */",
)

text = replace_once(
    text,
    f"\t\t\t\t\t{ids['APP_TARGET']} = {{\n\t\t\t\t\t\tCreatedOnToolsVersion = 26.5;\n\t\t\t\t\t}};\n",
    f"\t\t\t\t\t{ids['APP_TARGET']} = {{\n\t\t\t\t\t\tCreatedOnToolsVersion = 26.5;\n\t\t\t\t\t}};\n"
    f"\t\t\t\t\t{ids['TEST_TARGET']} = {{\n\t\t\t\t\t\tCreatedOnToolsVersion = 26.5;\n\t\t\t\t\t\tTestTargetID = {ids['APP_TARGET']};\n\t\t\t\t\t}};\n",
)

text = replace_once(
    text,
    f"\t\t\ttargets = (\n\t\t\t\t{ids['APP_TARGET']} /* MovieQuoteTrivia */,\n\t\t\t);\n",
    f"\t\t\ttargets = (\n\t\t\t\t{ids['APP_TARGET']} /* MovieQuoteTrivia */,\n\t\t\t\t{ids['TEST_TARGET']} /* MovieQuoteTriviaUITests */,\n\t\t\t);\n",
)

text = replace_once(
    text,
    "/* End PBXResourcesBuildPhase section */",
    f'''\t\t{ids["TEST_RESOURCES"]} /* Resources */ = {{
\t\t\tisa = PBXResourcesBuildPhase;
\t\t\tbuildActionMask = 2147483647;
\t\t\tfiles = (
\t\t\t);
\t\t\trunOnlyForDeploymentPostprocessing = 0;
\t\t}};
/* End PBXResourcesBuildPhase section */''',
)

text = replace_once(
    text,
    "/* End PBXSourcesBuildPhase section */",
    f'''\t\t{ids["TEST_SOURCES"]} /* Sources */ = {{
\t\t\tisa = PBXSourcesBuildPhase;
\t\t\tbuildActionMask = 2147483647;
\t\t\tfiles = (
\t\t\t);
\t\t\trunOnlyForDeploymentPostprocessing = 0;
\t\t}};
/* End PBXSourcesBuildPhase section */''',
)

target_dependency = f'''
/* Begin PBXTargetDependency section */
\t\t{ids["TEST_DEPENDENCY"]} /* PBXTargetDependency */ = {{
\t\t\tisa = PBXTargetDependency;
\t\t\ttarget = {ids["APP_TARGET"]} /* MovieQuoteTrivia */;
\t\t\ttargetProxy = {ids["TEST_PROXY"]} /* PBXContainerItemProxy */;
\t\t}};
/* End PBXTargetDependency section */
'''

text = replace_once(
    text,
    "/* Begin XCBuildConfiguration section */",
    target_dependency + "\n/* Begin XCBuildConfiguration section */",
)

test_configs = f'''\t\t{ids["TEST_DEBUG"]} /* Debug */ = {{
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {{
\t\t\t\tALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES = YES;
\t\t\t\tCODE_SIGN_STYLE = Automatic;
\t\t\t\tCURRENT_PROJECT_VERSION = 1;
\t\t\t\tDEVELOPMENT_TEAM = 5M42W7MT24;
\t\t\t\tINFOPLIST_FILE = MovieQuoteTriviaUITests/Info.plist;
\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 26.5;
\t\t\t\tLD_RUNPATH_SEARCH_PATHS = (
\t\t\t\t\t"$(inherited)",
\t\t\t\t\t"@executable_path/Frameworks",
\t\t\t\t\t"@loader_path/Frameworks",
\t\t\t\t);
\t\t\t\tMARKETING_VERSION = 1.0;
\t\t\t\tONLY_ACTIVE_ARCH = YES;
\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.jamesmoran.MovieQuoteTriviaUITests;
\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";
\t\t\t\tSDKROOT = iphoneos;
\t\t\t\tSWIFT_VERSION = 5.0;
\t\t\t\tTARGETED_DEVICE_FAMILY = "1,2";
\t\t\t\tTEST_TARGET_NAME = MovieQuoteTrivia;
\t\t\t}};
\t\t\tname = Debug;
\t\t}};
\t\t{ids["TEST_RELEASE"]} /* Release */ = {{
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {{
\t\t\t\tALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES = YES;
\t\t\t\tCODE_SIGN_STYLE = Automatic;
\t\t\t\tCURRENT_PROJECT_VERSION = 1;
\t\t\t\tDEVELOPMENT_TEAM = 5M42W7MT24;
\t\t\t\tINFOPLIST_FILE = MovieQuoteTriviaUITests/Info.plist;
\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 26.5;
\t\t\t\tLD_RUNPATH_SEARCH_PATHS = (
\t\t\t\t\t"$(inherited)",
\t\t\t\t\t"@executable_path/Frameworks",
\t\t\t\t\t"@loader_path/Frameworks",
\t\t\t\t);
\t\t\t\tMARKETING_VERSION = 1.0;
\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.jamesmoran.MovieQuoteTriviaUITests;
\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";
\t\t\t\tSDKROOT = iphoneos;
\t\t\t\tSWIFT_VERSION = 5.0;
\t\t\t\tTARGETED_DEVICE_FAMILY = "1,2";
\t\t\t\tTEST_TARGET_NAME = MovieQuoteTrivia;
\t\t\t}};
\t\t\tname = Release;
\t\t}};
'''

text = replace_once(
    text,
    "/* End XCBuildConfiguration section */",
    test_configs + "/* End XCBuildConfiguration section */",
)

test_config_list = f'''\t\t{ids["TEST_CONFIG_LIST"]} /* Build configuration list for PBXNativeTarget "MovieQuoteTriviaUITests" */ = {{
\t\t\tisa = XCConfigurationList;
\t\t\tbuildConfigurations = (
\t\t\t\t{ids["TEST_DEBUG"]} /* Debug */,
\t\t\t\t{ids["TEST_RELEASE"]} /* Release */,
\t\t\t);
\t\t\tdefaultConfigurationIsVisible = 0;
\t\t\tdefaultConfigurationName = Release;
\t\t}};
'''

text = replace_once(
    text,
    "/* End XCConfigurationList section */",
    test_config_list + "/* End XCConfigurationList section */",
)

project_path.write_text(text)
print("Added MovieQuoteTriviaUITests target to project.pbxproj")
