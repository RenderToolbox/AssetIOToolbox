classdef VsaExamplesTests < matlab.unittest.TestCase
    % Test listing and getting some expected example assets.
    
    methods (Test)
        
        function testListTypes(testCase)
            types = vsaListTypes('locations', {'examples'});
            sortedTypes = sort(types);
            expectedTypes = { ...
                'BaseScenes', 'Illuminants', 'IndicesOfRefraction', ...
                'Objects', 'Reflectances', 'Textures'};
            testCase.assertEqual(sortedTypes, expectedTypes);
        end
        
        function testListExistingNames(testCase)
            names = vsaListAssets('BaseScenes', 'locations', {'examples'});
            sortedNames = sort(names);
            expectedNames = { ...
                'CheckerBoard', 'IndoorPlant', 'Library', ...
                'Mill', 'TableChairs', 'Warehouse'};
            testCase.assertEqual(sortedNames, expectedNames);
        end
        
        function testListBogusNames(testCase)
            names = vsaListAssets('Bogus', 'locations', {'examples'});
            testCase.assertEmpty(names);
        end
        
        function testGetExistingInfo(testCase)
            [info, location] = vsaGetInfo('BaseScenes', 'CheckerBoard', 'locations', {'examples'});
            testCase.assertEqual(location, 'examples');
            testCase.assertNotEmpty(info);
            testCase.assertInstanceOf(info, 'struct');
        end
        
        function testGetBogusInfo(testCase)
            [info, location] = vsaGetInfo('Bogus', 'CheckerBoard', 'locations', {'examples'});
            testCase.assertEmpty(info);
            testCase.assertEmpty(location);
            
            [info, location] = vsaGetInfo('BaseScenes', 'Bogus', 'locations', {'examples'});
            testCase.assertEmpty(info);
            testCase.assertEmpty(location);
        end
        
        function testGetExistingFiles(testCase)
            [files, location] = vsaGetFiles('BaseScenes', 'CheckerBoard', 'locations', {'examples'});
            testCase.assertEqual(location, 'examples');
            testCase.assertNotEmpty(files);
            testCase.assertInstanceOf(files, 'cell');
        end
        
        function testGetBogusFiles(testCase)
            [files, location] = vsaGetFiles('Bogus', 'CheckerBoard', 'locations', {'examples'});
            testCase.assertEmpty(files);
            testCase.assertEmpty(location);
            
            [files, location] = vsaGetFiles('BaseScenes', 'Bogus', 'locations', {'examples'});
            testCase.assertEmpty(files);
            testCase.assertEmpty(location);
        end
        
    end
end