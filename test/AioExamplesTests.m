classdef AioExamplesTests < matlab.unittest.TestCase
    % Test listing and getting some expected example assets.
    
    methods (Test)
        
        function testListTypes(testCase)
            types = aioListTypes('locations', {'examples'});
            sortedTypes = sort(types);
            expectedTypes = { ...
                'BaseScenes', 'Illuminants', 'IndicesOfRefraction', ...
                'Objects', 'Reflectances', 'Textures'};
            testCase.assertEqual(sortedTypes, expectedTypes);
        end
        
        function testListExistingNames(testCase)
            names = aioListAssets('BaseScenes', 'locations', {'examples'});
            sortedNames = sort(names);
            expectedNames = { ...
                'CheckerBoard', 'IndoorPlant', 'Library', ...
                'Mill', 'TableChairs', 'Warehouse'};
            testCase.assertEqual(sortedNames, expectedNames);
        end
        
        function testListBogusNames(testCase)
            names = aioListAssets('Bogus', 'locations', {'examples'});
            testCase.assertEmpty(names);
        end
        
        function testGetExistingInfo(testCase)
            [info, location] = aioGetInfo('BaseScenes', 'CheckerBoard', 'locations', {'examples'});
            testCase.assertEqual(location, 'examples');
            testCase.assertNotEmpty(info);
            testCase.assertInstanceOf(info, 'struct');
        end
        
        function testGetBogusInfo(testCase)
            [info, location] = aioGetInfo('Bogus', 'CheckerBoard', 'locations', {'examples'});
            testCase.assertEmpty(info);
            testCase.assertEmpty(location);
            
            [info, location] = aioGetInfo('BaseScenes', 'Bogus', 'locations', {'examples'});
            testCase.assertEmpty(info);
            testCase.assertEmpty(location);
        end
        
        function testGetExistingFiles(testCase)
            [files, location] = aioGetFiles('BaseScenes', 'CheckerBoard', 'locations', {'examples'});
            testCase.assertEqual(location, 'examples');
            testCase.assertNotEmpty(files);
            testCase.assertInstanceOf(files, 'cell');
        end
        
        function testGetBogusFiles(testCase)
            [files, location] = aioGetFiles('Bogus', 'CheckerBoard', 'locations', {'examples'});
            testCase.assertEmpty(files);
            testCase.assertEmpty(location);
            
            [files, location] = aioGetFiles('BaseScenes', 'Bogus', 'locations', {'examples'});
            testCase.assertEmpty(files);
            testCase.assertEmpty(location);
        end
        
    end
end