classdef AioLocalTests < matlab.unittest.TestCase
    % Test listing and getting some fixture assets in a temp folder.
    
    properties
        tempFolder = fullfile(tempdir(), 'AioLocalTests');
        fixtureFolder = fullfile(aioRoot(), 'test', 'fixture', 'local', '*');
        aioPrefs = struct('locations', aioLocation( ...
            'name', 'local', ...
            'strategy', 'AioFileSystemStrategy', ...
            'baseDir', fullfile(tempdir(), 'AioLocalTests')));
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
            types = aioListTypes('locations', {'local'}, ...
                'aioPrefs', testCase.aioPrefs);
            sortedTypes = sort(types);
            expectedTypes = { ...
                'BaseScenes', 'Illuminants', 'IndicesOfRefraction', ...
                'Objects', 'Reflectances'};
            testCase.assertEqual(sortedTypes, expectedTypes);
        end
        
        function testListExistingNames(testCase)
            names = aioListAssets('BaseScenes', ...
                'locations', {'local'}, ...
                'aioPrefs', testCase.aioPrefs);
            sortedNames = sort(names);
            expectedNames = {'CheckerBoard'};
            testCase.assertEqual(sortedNames, expectedNames);
        end
        
        function testListBogusNames(testCase)
            names = aioListAssets('Bogus', ...
                'locations', {'local'}, ...
                'aioPrefs', testCase.aioPrefs);
            testCase.assertEmpty(names);
        end
        
        function testGetExistingInfo(testCase)
            [info, location] = aioGetInfo('BaseScenes', 'CheckerBoard', ...
                'locations', {'local'}, ...
                'aioPrefs', testCase.aioPrefs);
            testCase.assertEqual(location, 'local');
            testCase.assertNotEmpty(info);
            testCase.assertInstanceOf(info, 'struct');
        end
        
        function testGetBogusInfo(testCase)
            [info, location] = aioGetInfo('Bogus', 'CheckerBoard', ...
                'locations', {'local'}, ...
                'aioPrefs', testCase.aioPrefs);
            testCase.assertEmpty(info);
            testCase.assertEmpty(location);
            
            [info, location] = aioGetInfo('BaseScenes', 'Bogus', ...
                'locations', {'local'}, ...);
                'aioPrefs', testCase.aioPrefs);
            testCase.assertEmpty(info);
            testCase.assertEmpty(location);
        end
        
        function testGetExistingFiles(testCase)
            [files, location] = aioGetFiles('BaseScenes', 'CheckerBoard', ...
                'locations', {'local'}, ...
                'aioPrefs', testCase.aioPrefs);
            testCase.assertEqual(location, 'local');
            testCase.assertNotEmpty(files);
            testCase.assertInstanceOf(files, 'cell');
        end
        
        function testGetBogusFiles(testCase)
            [files, location] = aioGetFiles('Bogus', 'CheckerBoard', ...
                'locations', {'local'}, ...
                'aioPrefs', testCase.aioPrefs);
            testCase.assertEmpty(files);
            testCase.assertEmpty(location);
            
            [files, location] = aioGetFiles('BaseScenes', 'Bogus', ...
                'locations', {'local'}, ...
                'aioPrefs', testCase.aioPrefs);
            testCase.assertEmpty(files);
            testCase.assertEmpty(location);
        end
        
    end
end