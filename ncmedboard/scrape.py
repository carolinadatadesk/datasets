import csv
import requests
from BeautifulSoup import BeautifulSoup

#EXCEPTIONS TO ADD:
#if td_tblLicenseeInfo_1_3 text == Denied, do not do any of this
#get the denied documents

url = 'http://wwwapps.ncmedboard.org/Clients/NCBOM/Public/LicenseeInformation/Details.aspx?&EntityID=3200624&PublicFile=1'

response = requests.get(url)
html = response.content

thisDoctor = []

soup = BeautifulSoup(html)
table = soup.find('table', attrs={'id': 'ctl00_ContentPlaceHolder1_dtgPostGrad'})


#LICENSE AND EXPIRATION
idEndings = ['_lblDateIssued', '_lblLicenseNumber', '_lblDateEnding']
licenseData = []

for i, ending in enumerate(idEndings):
    licenseData.append(soup.find('span', attrs={'id': 'ctl00_ContentPlaceHolder1' + ending}).contents[0].encode('utf-8'))

# thisDoctor.append(licenseData)


#SCHOOL OF GRADUATION AND GRADUATION YEAR
medicalSchool = soup.find('table', attrs={'id':'ctl00_ContentPlaceHolder1_dtgMedSchool'})

for row in medicalSchool.findAll('tr'):
    for i, cell in enumerate(row.findAll('td')):
        if i == 0:
            gradSchool = cell.text
            # print gradSchool
        elif i == 2:
            gradYear = cell.text
            # print gradYear

thisDoctor.append(gradSchool)
thisDoctor.append(gradYear)


outfile = open("./license.csv", "wb")
writer = csv.writer(outfile)
writer.writerow(thisDoctor)
