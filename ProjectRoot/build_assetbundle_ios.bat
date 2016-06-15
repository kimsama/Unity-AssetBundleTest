rem Build iOS platform assetbundles under the ./iOS/Bundles directory.

set PRJ_PATH=%cd%\iOS
@echo %PRJ_PATH%

Unity.exe -quit -batchmode -buildTarget ios -executeMethod ExportAssetbundle.Export -projectPath %PRJ_PATH%