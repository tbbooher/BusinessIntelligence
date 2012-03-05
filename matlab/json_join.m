function [ out ] = json_join(delimeter, varargin )
%json_join This function joins elements together. Simple. Input must be strings.

if strcmp(delimeter,'{')
  delimeter_end = '}';
 else
  delimeter_end = ']';
end

out = [delimeter varargin{1}];

for i = 2:length(varargin)
   out = sprintf('%s,%s',out, varargin{i});
end

out = sprintf('%s%s\n',out,delimiter_end);

end

