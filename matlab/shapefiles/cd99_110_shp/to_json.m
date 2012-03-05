function to_json(fid,input_data)

district_data.centroid = input_data.centroid;
district_data.lats = input_data.lats;
district_data.lons = input_data.lons;

dataname = 'district_data';

datastring = input_data.name;

numdata = max(size(fieldnames(eval(dataname))));

fdata = char(fieldnames(eval(dataname)));

fprintf(fid,'{ "%s" : {\n ',dataname);

for dataiter=1:numdata
  element_name = strtrim(fdata(dataiter,:));
  fprintf(fid,' "%s" : [ \n',element_name);
  stmp = sprintf('%s.%s',dataname,element_name);
  for i=1:(max(length(eval(stmp))))-1,
    stmp = sprintf('%s.%s(%i)',dataname,element_name,i);
    fprintf(fid,'%10.8g,\n',eval(stmp));
  end
  % now the end
  stmp2 =  sprintf('%s.%s',dataname,element_name);
  
  stmp = sprintf('%s.%s(%i)',dataname,element_name,(max(length(eval(stmp2)))));
  fprintf(fid,'%10.8g\n',eval(stmp));

  if dataiter == numdata ,
    fprintf(fid,'] \n');
  else
    fprintf(fid,'], \n');
  end

end

fprintf(fid,'} } \n');


end
