classdef AioLocalPutTests < matlab.unittest.TestCase
    % Test putting some assets in a temp folder.
    
    properties
        tempFolder = fullfile(tempdir(), 'AioLocalPutTests');
        aioPrefs = struct('locations', [ ...
            aioLocation( ...
            'name', 'local', ...
            'strategy', 'AioFileSystemStrategy', ...
            'baseDir', fullfile(tempdir(), 'AioLocalPutTests')), ...
            aioLocation( ...
            'name', 'examples', ...
            'strategy', 'AioFileSystemStrategy', ...
            'baseDir', AioExamplesTests.exampleFolder())]);
    end
    
    methods (TestMethodSetup)
        function resetFixtureAssets(testCase)
            % fresh temp folder
            if 7 == exist(testCase.tempFolder, 'dir')
                rmdir(testCase.tempFolder, 's')
            end
        end
    end
    
    methods (Test)
        
        function testPutWithNothing(testCase)
            [assetInfo, assetFiles] = aioPut('TestType', 'TestName', ...
                'location', 'local', ...
                'aioPrefs', testCase.aioPrefs);
            
            % info and files should be empty
            testCase.assertInstanceOf(assetInfo, 'struct');
            testCase.assertEmpty(fieldnames(assetInfo));
            testCase.assertInstanceOf(assetFiles, 'cell');
            testCase.assertEmpty(assetFiles);
        end
        
        function testPutWithInfo(testCase)
            randomValue = rand();
            [assetInfo, assetFiles] = aioPut('TestType', 'TestName', ...
                'location', 'local', ...
                'aioPrefs', testCase.aioPrefs, ...
                'randomValue', randomValue);
            
            % info should be as given, files should be empty
            testCase.assertInstanceOf(assetInfo, 'struct');
            testCase.assertEqual(assetInfo.randomValue, randomValue);
            testCase.assertInstanceOf(assetFiles, 'cell');
            testCase.assertEmpty(assetFiles);
        end
        
        function testPutWithFiles(testCase)
            testFiles = aioGetFiles('Reflectances', 'ColorChecker', ...
                'locations', {'examples'}, ...
                'aioPrefs', testCase.aioPrefs, ...
                'fullPaths', true);
            [assetInfo, assetFiles] = aioPut('TestType', 'TestName', ...
                'location', 'local', ...
                'aioPrefs', testCase.aioPrefs, ...
                'files', testFiles);
            
            % files should be as given, info should be empty
            testCase.assertInstanceOf(assetInfo, 'struct');
            testCase.assertEmpty(fieldnames(assetInfo));
            testCase.assertInstanceOf(assetFiles, 'cell');
            testCase.assertEqual(assetFiles, testFiles);
        end
        
        function testPutWithExtras(testCase)
            testFiles = aioGetFiles('Reflectances', 'ColorChecker', ...
                'locations', {'examples'}, ...
                'aioPrefs', testCase.aioPrefs, ...
                'fullPaths', true);
            [assetInfo, assetFiles] = aioPut('TestType', 'TestName', ...
                'location', 'local', ...
                'aioPrefs', testCase.aioPrefs, ...
                'extras', testFiles);
            
            % info and files should be empty
            testCase.assertInstanceOf(assetInfo, 'struct');
            testCase.assertEmpty(fieldnames(assetInfo));
            testCase.assertInstanceOf(assetFiles, 'cell');
            testCase.assertEmpty(assetFiles);
            
            % extras folder should exist with files as given
            extrasFolder = fullfile(testCase.aioPrefs.locations(1).config.baseDir, ...
                'TestType', 'TestName', 'extras');
            testCase.assertEqual(7, exist(extrasFolder, 'dir'));
            nFiles = numel(testFiles);
            for ff = 1:nFiles
                [~, testBase, testExt] = fileparts(testFiles{ff});
                extrasFile = fullfile(extrasFolder, [testBase, testExt]);
                testCase.assertEqual(2, exist(extrasFile, 'file'));
            end
        end
        
        function testMergeInfo(testCase)
            randomValue = rand();
            assetInfo = aioPut('TestType', 'TestName', ...
                'location', 'local', ...
                'aioPrefs', testCase.aioPrefs, ...
                'randomValue', randomValue);
            
            testCase.assertInstanceOf(assetInfo, 'struct');
            testCase.assertEqual(assetInfo.randomValue, randomValue);
            
            anotherRandomValue = rand();
            assetInfo = aioPut('TestType', 'TestName', ...
                'location', 'local', ...
                'aioPrefs', testCase.aioPrefs, ...
                'ifConflict', 'merge', ...
                'anotherRandomValue', anotherRandomValue);
            
            % info should contain fields from two put calls
            testCase.assertInstanceOf(assetInfo, 'struct');
            testCase.assertEqual(assetInfo.randomValue, randomValue);
            testCase.assertEqual(assetInfo.anotherRandomValue, anotherRandomValue);
        end
        
        function testMergeFiles(testCase)
            [~, assetFiles] = aioPut('TestType', 'TestName', ...
                'location', 'local', ...
                'aioPrefs', testCase.aioPrefs);
            
            testCase.assertInstanceOf(assetFiles, 'cell');
            testCase.assertEmpty(assetFiles);
            
            testFiles = aioGetFiles('Reflectances', 'ColorChecker', ...
                'locations', {'examples'}, ...
                'aioPrefs', testCase.aioPrefs, ...
                'fullPaths', true);
            [~, assetFiles] = aioPut('TestType', 'TestName', ...
                'location', 'local', ...
                'aioPrefs', testCase.aioPrefs, ...
                'ifConflict', 'merge', ...
                'files', testFiles);
            
            % should see files from second put call
            testCase.assertInstanceOf(assetFiles, 'cell');
            testCase.assertEqual(assetFiles, testFiles);
        end
        
        function testReplace(testCase)
            randomValue = rand();
            assetInfo = aioPut('TestType', 'TestName', ...
                'location', 'local', ...
                'aioPrefs', testCase.aioPrefs, ...
                'randomValue', randomValue);
            
            testCase.assertInstanceOf(assetInfo, 'struct');
            testCase.assertEqual(assetInfo.randomValue, randomValue);
            
            anotherRandomValue = rand();
            assetInfo = aioPut('TestType', 'TestName', ...
                'location', 'local', ...
                'aioPrefs', testCase.aioPrefs, ...
                'ifConflict', 'replace', ...
                'anotherRandomValue', anotherRandomValue);
            
            % should see info from second put call, not the first
            testCase.assertInstanceOf(assetInfo, 'struct');
            testCase.assertEqual(fieldnames(assetInfo), {'anotherRandomValue'});
            testCase.assertEqual(assetInfo.anotherRandomValue, anotherRandomValue);
        end
        
        function testError(testCase)
            randomValue = rand();
            assetInfo = aioPut('TestType', 'TestName', ...
                'location', 'local', ...
                'aioPrefs', testCase.aioPrefs, ...
                'randomValue', randomValue);
            
            testCase.assertInstanceOf(assetInfo, 'struct');
            testCase.assertEqual(assetInfo.randomValue, randomValue);
            
            % should get an error on second put call
            errorId = 'no error yet';
            try
                anotherRandomValue = rand();
                aioPut('TestType', 'TestName', ...
                    'location', 'local', ...
                    'aioPrefs', testCase.aioPrefs, ...
                    'ifConflict', 'error', ...
                    'anotherRandomValue', anotherRandomValue);
            catch err
                errorId = err.identifier;
            end
            
            testCase.assertEqual(errorId, 'AioLocationStrategy:putConflict');
        end
        
        function testSkip(testCase)
            randomValue = rand();
            assetInfo = aioPut('TestType', 'TestName', ...
                'location', 'local', ...
                'aioPrefs', testCase.aioPrefs, ...
                'randomValue', randomValue);
            
            testCase.assertInstanceOf(assetInfo, 'struct');
            testCase.assertEqual(assetInfo.randomValue, randomValue);
            
            anotherRandomValue = rand();
            assetInfo = aioPut('TestType', 'TestName', ...
                'location', 'local', ...
                'aioPrefs', testCase.aioPrefs, ...
                'ifConflict', 'skip', ...
                'anotherRandomValue', anotherRandomValue);
            
            % should see info from first put call, not the second
            testCase.assertInstanceOf(assetInfo, 'struct');
            testCase.assertEqual(fieldnames(assetInfo), {'randomValue'});
            testCase.assertEqual(assetInfo.randomValue, randomValue);
        end
    end
end