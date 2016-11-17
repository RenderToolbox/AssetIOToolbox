classdef VsaLocalTests < matlab.unittest.TestCase
    % Test listing and getting some fixture assets in a temp folder.
    
    properties
        tempFolder = fullfile(tempdir(), 'VsaLocalTests');
        fixtureFolder = fullfile(vsaRoot(), 'test', 'fixture', 'local', '*');
        vsaPrefs = struct('locations', vsaLocation( ...
            'name', 'local', ...
            'strategy', 'VsaFileSystemStrategy', ...
            'baseDir', fullfile(tempdir(), 'VsaLocalTests')));
    end
    
    methods (TestClassSetup)
        function resetFixtureAssets(testCase)
            % fresh temp folder
            if 7 == exist(testCase.tempFolder, 'dir')
                rmdir(testCase.tempFolder, 's')
            end
            
            % copy in fixture assets
            copyfile(testCase.fixtureFolder, testCase.tempFolder, 'f');
        end
    end
    
    methods (Test)
        
        function testListTypes(testCase)
            types = vsaListTypes('locations', {'local'}, ...
                'vsaPrefs', testCase.vsaPrefs);
            sortedTypes = sort(types);
            expectedTypes = { ...
                'BaseScenes', 'Illuminants', 'IndicesOfRefraction', ...
                'Objects', 'Reflectances'};
            testCase.assertEqual(sortedTypes, expectedTypes);
        end
        
        function testListExistingNames(testCase)
            names = vsaListAssets('BaseScenes', ...
                'locations', {'local'}, ...
                'vsaPrefs', testCase.vsaPrefs);
            sortedNames = sort(names);
            expectedNames = {'CheckerBoard'};
            testCase.assertEqual(sortedNames, expectedNames);
        end
        
        function testListBogusNames(testCase)
            names = vsaListAssets('Bogus', ...
                'locations', {'local'}, ...
                'vsaPrefs', testCase.vsaPrefs);
            testCase.assertEmpty(names);
        end
        
        function testGetExistingInfo(testCase)
            [info, location] = vsaGetInfo('BaseScenes', 'CheckerBoard', ...
                'locations', {'local'}, ...
                'vsaPrefs', testCase.vsaPrefs);
            testCase.assertEqual(location, 'local');
            testCase.assertNotEmpty(info);
            testCase.assertInstanceOf(info, 'struct');
        end
        
        function testGetBogusInfo(testCase)
            [info, location] = vsaGetInfo('Bogus', 'CheckerBoard', ...
                'locations', {'local'}, ...
                'vsaPrefs', testCase.vsaPrefs);
            testCase.assertEmpty(info);
            testCase.assertEmpty(location);
            
            [info, location] = vsaGetInfo('BaseScenes', 'Bogus', ...
                'locations', {'local'}, ...);
                'vsaPrefs', testCase.vsaPrefs);
            testCase.assertEmpty(info);
            testCase.assertEmpty(location);
        end
        
        function testGetExistingFiles(testCase)
            [files, location] = vsaGetFiles('BaseScenes', 'CheckerBoard', ...
                'locations', {'local'}, ...
                'vsaPrefs', testCase.vsaPrefs);
            testCase.assertEqual(location, 'local');
            testCase.assertNotEmpty(files);
            testCase.assertInstanceOf(files, 'cell');
        end
        
        function testGetBogusFiles(testCase)
            [files, location] = vsaGetFiles('Bogus', 'CheckerBoard', ...
                'locations', {'local'}, ...
                'vsaPrefs', testCase.vsaPrefs);
            testCase.assertEmpty(files);
            testCase.assertEmpty(location);
            
            [files, location] = vsaGetFiles('BaseScenes', 'Bogus', ...
                'locations', {'local'}, ...
                'vsaPrefs', testCase.vsaPrefs);
            testCase.assertEmpty(files);
            testCase.assertEmpty(location);
        end
        
    end
end