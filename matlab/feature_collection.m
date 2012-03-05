classdef feature_collection
    %UNTITLED6 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        feature_list
    end
    
    methods
        function obj = feature_collection
%            {"type":"FeatureCollection","features":[ 
            districts = shaperead('cd99_110','UseGeoCoords',true);
            d = districts(1);
            obj.feature_list = feature(d);
        end
        
        function save_json(obj)
            features = savejson();
            json_join('"type":"FeatureCollection"',features);
        end
    end
    
end

