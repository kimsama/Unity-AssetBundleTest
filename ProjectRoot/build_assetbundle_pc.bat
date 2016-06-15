rem Build PC stand-alone platform assetbundles under the ./Working/Bundles directory.

set PRJ_PATH=%cd%\Working
@echo %PRJ_PATH%

Unity.exe -quit -batchmode -buildTarget win32 -executeMethod ExportAssetbundle.Export -projectPath %PRJ_PATH%