# AssetIOToolbox
Data access API for digital assets stored in multiple locations.

# Overview
AssetIOToolbox is a set of utilities for storing and accessing digital assets, like files and metadata about the files.  It establishes a convention for how the assets should be organized, allowing the same API to be use for assets across multiple configured locations.

# Installation
The best way to get AssetIOToolbox is to use the [ToolboxToolbox](https://github.com/ToolboxHub/ToolboxToolbox).

If you have the ToolboxToolbox, then getting AssetIOToolbox becomes a one-liner:
```
tbUse('AssetIOToolbox');
```

## Preferences
The ToolboxToolbox will also create a configuration script which you can edit with local preferences, like where to look for assets.  This script will be named `AssetIOToolbox.m`.  The default folder would be in your Matlab [userpath](https://www.mathworks.com/help/matlab/ref/userpath.html).  For example: 
```
~/Documents/MATLAB/AssetIOToolbox.m
```

Here are some preferences you might wish to edit in this script:
 - where to look for locally stored assets -- edit [here](aioMachineSetup.m#L10)
 - where to look for remotely stored assets, using [RemoteDataToolbox](https://github.com/isetbio/RemoteDataToolbox): edit [here](vsaMachineSetup.m#L21)

Next time you do `tbUse('AssetIOToolbox')` your custom preferences will be set up.

# Organization and API
AssetIOToolbox uses two levels of organization for assets: each asset has a "type" and a "name".

Each asset may contain several files, including:
  - an "info" file which contains any data or metadata for the asset
  - zero or more data files of other types, like 3D models, textures, etc.
  - zero or more "extra" files, like a readme, license notices, etc.

## Listing types and names
The utility [aioListTypes()](api/aioListTypes.m) helps navigate the types.  It reports available asset types, and the location where each type was found.  This example lists only `test` types which are included with this repository.  See below for more about asset locations.
```
>> [types, locations] = aioListTypes()
types = 
    'BaseScenes'    'Illuminants'    'IndicesOfRefraction'    'Objects'    'Reflectances'
locations = 
    'test'    'test'    'test'    'test'    'test'
```

The utility [aioListAssets()](api/aioListAssets.m) helps navigate the assets within each type.  It reports the names of available assets for a given type, and the location where each asset was found.  This example shows only one results, names `CheckerBoard`.  In general, there could be many results.
```
>> [names, locations] = aioListAssets('BaseScenes')
names = 
    'CheckerBoard'
locations = 
    'test'
```

## Getting asset data
The utility [aioGetInfo()](api/aioGetInfo.m) finds and loads the "info" file for a particular asset.  This may contain any data or metadata for an asset.  For some assets, the info may be empty.  In this example, the info file contains annotations for a 3D model.
```
>> assetInfo = aioGetInfo('BaseScenes', 'CheckerBoard')
assetInfo = 
        cameraSlots: [1x1 struct]
           lightBox: [3x2 double]
    lightExcludeBox: [3x2 double]
           lightIds: {'TopLeftLight-mesh'  'RightLight-mesh'  'BottomLight-mesh'}
        materialIds: {1x28 cell}
               name: 'CheckerBoard'
          objectBox: [3x2 double]
```

The utility [aioGetFiles()](api/aioGetFiles.m) locates any data files for an asset.  In this example, the asset contains a Blender version and a Collada version of the same 3D model.
```
>> assetFiles = aioGetFiles('BaseScenes', 'CheckerBoard')
assetFiles = 
    '.../AssetIOToolbox/test/fixture/local/BaseScenes/CheckerBoard/CheckerBoard.blend'
    '.../AssetIOToolbox/test/fixture/local/BaseScenes/CheckerBoard/CheckerBoard.dae'
```

## Creating and updating assets
The utility [aioPut()](api/aioPut.m) creates or updates an asset with a given type and name.  It accepts a list of data flies and "extras" files to save with the asset.  Additional name-value pairs will be saved in the asset's info file.

If an asset with the same name and type already exists at the target location, this conflict can be resolved in one of several ways, including "skip", "error", "merge" or "replace".  See below for more about asset locations.

Here is an example that would replace one of the test assets that comes with this repository.
```
>> d65 = fullfile(rtbRoot(), 'RenderData', 'D65.spd');
aioPut('Illuminants', 'D65', ...
    'location', 'test', ...
    'files', {d65}, ...
    'ifConflict', 'replace');
```

# Asset Locations
The AssetIOToolbox API is intented to work for assets stored in multiple locations.  By default, these include:
  - "local" -- assets stored in a folder on the local file system
  - "remote" -- assets stored on a remote server ([TODO](https://github.com/RenderToolbox/VirtualScenesAssets/issues/3))
  - "test" -- a few assets stored [in this repository](test/fixture/local), for demonstration and testing

By default, the listing and getting utilities search these three locations, in that order, to locate assets.  These are established in the [toolbox preferences script](aioMachineSetup.m) described above.

Each utility also accepts an optional `aioPrefs` parameter, which may be used to override the default set of configured locations, and a `locations` parameter which may be used to override the default location search order.


## Location strategies
Each asset location corresponds to an implementation of the abstract [AioLocationStrategy](strategies/AioLocationStrategy.m) class.  This class outlines the operations required for working with an asset location, like listing, reading, writing and deleting assets by type and name.


# Related Tools
AssetIOToolbox has a small API and few required toolbox dependencies.  As such, it may be a useful component for many projects.  Two projects where we expect AssetIOToolbox to be used are:
  - [VirtualScenesEngine](https://github.com/RenderToolbox/VirtualScenesEngine), which re-combines assets into myraiad scenes for rendering and analysis
  - [RenderToolbox4](https://github.com/RenderToolbox/RenderToolbox4), which deals with scenes and rendering in general
