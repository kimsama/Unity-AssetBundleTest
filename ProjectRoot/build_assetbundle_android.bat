rem Build Android platform assetbundles under the ./Android/Bundles directory.

set PRJ_PATH=%cd%\Android
@echo %PRJ_PATH%

Unity.exe -quit -batchmode -buildTarget android -executeMethod ExportAssetbundle.Export -projectPath %PRJ_PATH%