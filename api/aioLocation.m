function location = vsaLocation(varargin)
% Make a well-formed struct to represent a location with assets.
%
% The idea is to represent a location that we want, using a consistent
% struct format.  Making the struct format consistent is useful because we
% can check for required fields.  We can also put lots of records together
% into a struct array, which is easier to work with than a cell array.
%
% location = vsaLocation() creates a placeholder record with the correct
% fields.
%
% location = vsaLocation( ... name, value) fills in the record with
% fields based on the given names-value pairs.  The recognized names are:
%   - 'name' -- unique name to identify the location.
%   - 'strategy' -- name of a class that extends VsaLocationStrategy
%   - 'config' -- struct of parameters to pass to the strategy constructor
%
% Unrecognized names and values will be added as fileds of the config
% struct.
%
% 2016 benjamin.heasly@gmail.com

parser = MipInputParser();
parser.KeepUnmatched = true;
parser.addParameter('name', '', @ischar);
parser.addParameter('strategy', '', @ischar);
parser.addParameter('config', struct(), @(val) isempty(val) || isstruct(val));
location = parser.parseMagically(struct());

additional = parser.Unmatched;
additionalFields = fieldnames(additional);
for aa = 1:numel(additionalFields)
    field = additionalFields{aa};
    location.config.(field) = additional.(field);
end
