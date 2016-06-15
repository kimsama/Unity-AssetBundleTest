using UnityEngine;
using System.Collections;
using UnityEditor;
using System.IO;

/// <summary>
/// An editor script which builds assetbundles.
/// </summary>
public class ExportAssetbundle
{
    [MenuItem("Export/Assetbundle")]
    public static void Export()
    {
        // Note we don't put the assetbundle under the ./Assets/ project folder
        // because the project folder is already linked with symbolic link.
        string path = Application.dataPath + "/../Bundles/";

        // See the directory is exist, if not, it makes a new one.
        if (!Directory.Exists(path))
            Directory.CreateDirectory(path);

        // Build assetbundles
        BuildPipeline.BuildAssetBundles(path);
    }
}