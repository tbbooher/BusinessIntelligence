d = xmlread('people.xml');

allPeople = d.getElementsByTagName('person');

fid = fopen('district_to_member.json','w');

for k = 0:allPeople.getLength-1
    thisPerson = allPeople.item(k);
    if strcmp(thisPerson.getAttribute('title'),'Rep.')
        d_id = char(thisPerson.getAttribute('id'));
        f_name = [d_id '-100px.jpeg'];
        m_name = char(thisPerson.getAttribute('name'));
        try
            movefile(['/Users/Tim/Sites/af/public/images/photos/' f_name], ['/Users/Tim/Sites/af/public/images/' f_name]);
        catch
            disp('error');
            disp(f_name);
        end
        district = sprintf('%02d',str2double(thisPerson.getAttribute('district')));
        if strcmp(district,'00')
           district = 'AL';
        end
        fwrite(fid,['"' char(thisPerson.getAttribute('state')) district '":{"member_id":' d_id ',"member_name":"' m_name '"},']);
    end
end

fclose(fid);