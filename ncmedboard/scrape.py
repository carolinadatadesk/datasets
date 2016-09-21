# import csv
import requests
from BeautifulSoup import BeautifulSoup

url = 'http://wwwapps.ncmedboard.org/Clients/NCBOM/Public/LicenseeInformation/Details.aspx?&EntityID=3200624&PublicFile=1'

response = requests.get(url)
html = response.content

list_of_rows = []

soup = BeautifulSoup(html)
table = soup.find('table', attrs={'id': 'ctl00_ContentPlaceHolder1_dtgPostGrad'})


id_endings = ['_lblDateIssued', '_lblLicenseNumber', '_lblDateEnding']
data = []

for i, ending in enumerate(id_endings):
    data.append(soup.find('span', attrs={'id': 'ctl00_ContentPlaceHolder1' + ending}).contents[0])
    # print data

schoolsAttended = soup.find('table', attrs={'id':'ctl00_ContentPlaceHolder1_dtgMedSchool'})
schoolString = [];
# print schools

for row in schoolsAttended.findAll('tr'):
    for i, cell in enumerate(row.findAll('td')):
        print 'start'
        cellText = cell.text.replace('Year of Graduation:', '')
        print cellText
        if cellText == "":
            schoolString.append(cell.text)
            print 'empty'



# for string in schoolString:
#     string.replace('Year of Graduation:', '')






# print dateIssued.contents[0]
# print licenseNumber.contents[0]
#
# outfile = open('./doctors.csv', 'wb')
# writer = csv.writer(outfile)
# writer.writerows(list_of_rows)

# for row in table.findAll('tr'):
#     for cell in row.findAll('td'):
#         print soup.prettify()
