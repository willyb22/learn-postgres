import csv, os, random
from itertools import product

first_names = ['Andi', 'Budi', 'Cantika', 'Deni', 'Evelyn']
last_names = ['Angela', 'Bardin', 'Cherry', 'Dave', 'Eel']
provinces = ['A', 'B', 'C']
districts = [f'd-{i:02}' for i in range(5)]
cities = [f'c-{i:02}' for i in range(5)]
subdistricts = [f'sd-{i:02}' for i in range(5)]
villages = [f'v-{i:02}' for i in range(5)]

degrees = ['D3', 'S1', 'S2', 'S3']
universities = [f'uni {chr(65+i)}' for i in range(26)]
majors = [f'major {chr(65+i)}' for i in range(10)]
# print(degrees, universities, majors)

def write_csv(filename, data_with_header):
    with open(filename, "w+", newline="") as file:
        writer = csv.writer(file)
        writer.writerows(data_with_header)

def generate_data(data_path):
    random.seed(0)
    filenamef = lambda x: os.path.join(data_path, x)
    # provinces
    province_df = [['name']]
    write_csv(filenamef('province.csv'), [['name']]+[[p] for p in provinces])
    # districts, subdistricts, villages
    district_df = [['province', 'city', 'name']]
    subdistrict_df = [['district', 'name']]
    village_df = [['subdistrict','name', 'zip_code']]
    prov_ids = random.sample(list(range(1, len(cities))), len(provinces)-1)
    prov_id = 0
    zip_code = 1
    for i_c, c in enumerate(cities):
        if i_c >= prov_ids[prov_id]:
            prov_id += 1
        for i in range(random.randint(1, len(districts))):
            district_name = c+'_'+districts[i]
            district_df.append([provinces[prov_id], c, district_name])
            for j in range(random.randint(1, len(subdistricts))):
                subdistrict_name = district_name+'_'+subdistricts[j]
                subdistrict_df.append([district_name, subdistrict_name])
                for k in range(random.randint(1, len(villages))):
                    village_name = subdistrict_name+'_'+villages[k]
                    village_df.append([subdistrict_name, village_name, f'{zip_code:05}'])
                    zip_code += 1
    
    write_csv(filenamef('district.csv'), district_df)
    write_csv(filenamef('subdistrict.csv'), subdistrict_df)
    write_csv(filenamef('village.csv'), village_df)

    # cities = set(map(lambda x: x[1], district_df))
    uni_ids = list(range(len(universities)))
    random.shuffle(uni_ids)
    prov_uni_dict = dict()
    min_uni_per_prov = 2
    for i, p in enumerate(provinces):
        prov_uni_dict[p] = [uni_ids[j + 2*i] for j in range(min_uni_per_prov)]
    id_slices = random.sample(list(range(min_uni_per_prov*len(provinces)+1, len(universities)-1)), len(provinces)-1)
    id_slices = [min_uni_per_prov*len(provinces)] + sorted(id_slices) + [len(universities)]
    for i, p in enumerate(provinces):
        prov_uni_dict[p].extend([uni_ids[j] for j in range(id_slices[i], id_slices[i+1])])

    employee_df = [['name', 'gender', 'email', 'address', 'education']]
    for fn, ln in product(first_names, last_names):
        name = fn + ' ' + ln
        email = f'{fn}.{ln}@gmail.com'
        gender = random.sample(['male', 'female'], 1)[0]
        street1 = f'Jl. {chr(64+random.randint(1, 26))}-street'
        street2 = f'RT{random.randint(1,5):02}/RW{random.randint(1,5):02}'
        village_id = random.randint(1, len(village_df))
        subdistrict_name = village_df[village_id][0]
        village_name = village_df[village_id][1]
        zip_code = village_df[village_id][2]
        district_name = list(filter(lambda x: x[1]==subdistrict_name, subdistrict_df))[0][0]
        province, city_name = list(filter(lambda x: x[2]==district_name, district_df))[0][:-1]
        university = universities[random.sample(prov_uni_dict[province], 1)[0]]
        major = random.sample(majors, 1)[0]
        degree = random.sample(degrees, 1)[0]
        employee_df.append([
            name,
            gender,
            email,
            ", ".join([street1, street2, f'Gg. {village_name}', f'Kel. {subdistrict_name}',
                       f'Kec. {district_name}', f'Kota {city_name}', province, zip_code]),
            "-".join([degree, major, university])
        ])
    write_csv(filenamef('employee.csv'), employee_df)
    write_csv(filenamef('major.csv'), [['name']]+[[m] for m in majors])
    write_csv(filenamef('university.csv'), [['name']]+[[u] for u in universities])


if __name__=="__main__":
    data_path = r'E:\willy\projects\test\data\init-data'
    generate_data(data_path)