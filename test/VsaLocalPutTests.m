classdef VsaLocalPutTests < matlab.unittest.TestCase
    % Test putting some assets in a temp folder.
    
    properties
        tempFolder = fullfile(tempdir(), 'VsaLocalPutTests');
        vsaPrefs = struct('locations', vsaLocation( ...
            'name', 'local', ...
            'strategy', 'VsaFileSystemStrategy', ...
            'baseDir', fullfile(tempdir(), 'VsaLocalPutTests')));
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
            [assetInfo, assetFiles] = vsaPut('TestType', 'TestName', ...
                'location', 'local', ...
                'vsaPrefs', testCase.vsaPrefs);
            
            % info and files should be empty
            testCase.assertInstanceOf(assetInfo, 'struct');
            testCase.assertEmpty(fieldnames(assetInfo));
            testCase.assertInstanceOf(assetFiles, 'cell');
            testCase.assertEmpty(assetFiles);
        end
        
        function testPutWithInfo(testCase)
            randomValue = rand();
            [assetInfo, assetFiles] = vsaPut('TestType', 'TestName', ...
                'location', 'local', ...
                'vsaPrefs', testCase.vsaPrefs, ...
                'randomValue', randomValue);
            
            % info should be as given, files should be empty
            testCase.assertInstanceOf(assetInfo, 'struct');
            testCase.assertEqual(assetInfo.randomValue, randomValue);
            testCase.assertInstanceOf(assetFiles, 'cell');
            testCase.assertEmpty(assetFiles);
        end
        
        function testPutWithFiles(testCase)
            testFiles = vsaGetFiles('Reflectances', 'ColorChecker', ...
                'locations', {'examples'}, ...
                'fullPaths', true);
            [assetInfo, assetFiles] = vsaPut('TestType', 'TestName', ...
                'location', 'local', ...
                'vsaPrefs', testCase.vsaPrefs, ...
                'files', testFiles);
            
            % files should be as given, info should be empty
            testCase.assertInstanceOf(assetInfo, 'struct');
            testCase.assertEmpty(fieldnames(assetInfo));
            testCase.assertInstanceOf(assetFiles, 'cell');
            testCase.assertEqual(assetFiles, testFiles);
        end
        
        function testPutWithExtras(testCase)
            testFiles = vsaGetFiles('Reflectances', 'ColorChecker', ...
                'locations', {'examples'}, ...
                'fullPaths', true);
            [assetInfo, assetFiles] = vsaPut('TestType', 'TestName', ...
                'location', 'local', ...
                'vsaPrefs', testCase.vsaPrefs, ...
                'extras', testFiles);
            
            % info and files should be empty
            testCase.assertInstanceOf(assetInfo, 'struct');
            testCase.assertEmpty(fieldnames(assetInfo));
            testCase.assertInstanceOf(assetFiles, 'cell');
            testCase.assertEmpty(assetFiles);
            
            % extras folder should exist with files as given
            extrasFolder = fullfile(testCase.vsaPrefs.locations(1).config.baseDir, ...
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
            assetInfo = vsaPut('TestType', 'TestName', ...
                'location', 'local', ...
                'vsaPrefs', testCase.vsaPrefs, ...
                'randomValue', randomValue);
            
            testCase.assertInstanceOf(assetInfo, 'struct');
            testCase.assertEqual(assetInfo.randomValue, randomValue);
            
            anotherRandomValue = rand();
            assetInfo = vsaPut('TestType', 'TestName', ...
                'location', 'local', ...
                'vsaPrefs', testCase.vsaPrefs, ...
                'ifConflict', 'merge', ...
                'anotherRandomValue', anotherRandomValue);
            
            % info should contain fields from two put calls
            testCase.assertInstanceOf(assetInfo, 'struct');
            testCase.assertEqual(assetInfo.randomValue, randomValue);
            testCase.assertEqual(assetInfo.anotherRandomValue, anotherRandomValue);
        end
        
        function testMergeFiles(testCase)
            [~, assetFiles] = vsaPut('TestType', 'TestName', ...
                'location', 'local', ...
                'vsaPrefs', testCase.vsaPrefs);
            
            testCase.assertInstanceOf(assetFiles, 'cell');
            testCase.assertEmpty(assetFiles);
            
            testFiles = vsaGetFiles('Reflectances', 'ColorChecker', ...
                'locations', {'examples'}, ...
                'fullPaths', true);
            [~, assetFiles] = vsaPut('TestType', 'TestName', ...
                'location', 'local', ...
                'vsaPrefs', testCase.vsaPrefs, ...
                'ifConflict', 'merge', ...
                'files', testFiles);
            
            % should see files from second put call
            testCase.assertInstanceOf(assetFiles, 'cell');
            testCase.assertEqual(assetFiles, testFiles);
        end
        
        function testReplace(testCase)
            randomValue = rand();
            assetInfo = vsaPut('TestType', 'TestName', ...
                'location', 'local', ...
                'vsaPrefs', testCase.vsaPrefs, ...
                'randomValue', randomValue);
            
            testCase.assertInstanceOf(assetInfo, 'struct');
            testCase.assertEqual(assetInfo.randomValue, randomValue);
            
            anotherRandomValue = rand();
            assetInfo = vsaPut('TestType', 'TestName', ...
                'location', 'local', ...
                'vsaPrefs', testCase.vsaPrefs, ...
                'ifConflict', 'replace', ...
                'anotherRandomValue', anotherRandomValue);
            
            % should see info from second put call, not the first
            testCase.assertInstanceOf(assetInfo, 'struct');
            testCase.assertEqual(fieldnames(assetInfo), {'anotherRandomValue'});
            testCase.assertEqual(assetInfo.anotherRandomValue, anotherRandomValue);
        end
        
        function testError(testCase)
            randomValue = rand();
            assetInfo = vsaPut('TestType', 'TestName', ...
                'location', 'local', ...
                'vsaPrefs', testCase.vsaPrefs, ...
                'randomValue', randomValue);
            
            testCase.assertInstanceOf(assetInfo, 'struct');
            testCase.assertEqual(assetInfo.randomValue, randomValue);
            
            % should get an error on second put call
            errorId = 'no error yet';
            try
                anotherRandomValue = rand();
                vsaPut('TestType', 'TestName', ...
                    'location', 'local', ...
                    'vsaPrefs', testCase.vsaPrefs, ...
                    'ifConflict', 'error', ...
                    'anotherRandomValue', anotherRandomValue);
            catch err
                errorId = err.identifier;
            end
            
            testCase.assertEqual(errorId, 'VsaLocationStrategy:putConflict');
        end
        
        function testSkip(testCase)
            randomValue = rand();
            assetInfo = vsaPut('TestType', 'TestName', ...
                'location', 'local', ...
                'vsaPrefs', testCase.vsaPrefs, ...
                'randomValue', randomValue);
            
            testCase.assertInstanceOf(assetInfo, 'struct');
            testCase.assertEqual(assetInfo.randomValue, randomValue);
            
            anotherRandomValue = rand();
            assetInfo = vsaPut('TestType', 'TestName', ...
                'location', 'local', ...
                'vsaPrefs', testCase.vsaPrefs, ...
                'ifConflict', 'skip', ...
                'anotherRandomValue', anotherRandomValue);
            
            % should see info from first put call, not the second
            testCase.assertInstanceOf(assetInfo, 'struct');
            testCase.assertEqual(fieldnames(assetInfo), {'randomValue'});
            testCase.assertEqual(assetInfo.randomValue, randomValue);
        end
    end
end