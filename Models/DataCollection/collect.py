
# data quality ~ : https://nipil.org/2018/02/17/api-velib-metropole-manque-de-fiabilite.html

import requests


# curl 'https://www.velib-metropole.fr/webapi/map/details?gpsTopLatitude=48.90&gpsTopLongitude=2.46&gpsBotLatitude=48.81&gpsBotLongitude=2.22&zoomLevel=15' -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:99.0) Gecko/20100101 Firefox/99.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8' -H 'Accept-Language: fr,fr-FR;q=0.8,en-US;q=0.5,en;q=0.3' -H 'Accept-Encoding: gzip, deflate, br' -H 'Connection: keep-alive' -H 'Cookie: ApplicationGatewayAffinityCORS=0e6278228d2a59543f2d40831e3a1913; ApplicationGatewayAffinity=0e6278228d2a59543f2d40831e3a1913; dtCookie=v_4_srv_2_sn_C0316E69BA482D89436E984C8275BC2E_perc_100000_ol_0_mul_1_app-3A707e3a456ac14761_1; __cf_bm=F0ADathi8EnUdJOnUI_i3SA2gnNa6.GCk_5PH6FkCKg-1650455459-0-Adt90Xce3fFhrm+ZJ0CoUlXZW3uTWong1EZiqUI1CY6t2JbKASnpHe0fnyQuJgRcJ0Q+eYLTidvMWi7zCTRwrEU=' -H 'Upgrade-Insecure-Requests: 1' -H 'Sec-Fetch-Dest: document' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-Site: none' -H 'Sec-Fetch-User: ?1'

headers = {'User-Agent': 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:99.0) Gecko/20100101 Firefox/99.0'}

s = requests.session()

#print(s.get('https://www.velib-metropole.fr/webapi/map/details', headers=headers))

res = s.get('https://www.velib-metropole.fr/webapi/map/details?gpsTopLatitude=48.90&gpsTopLongitude=2.46&gpsBotLatitude=48.81&gpsBotLongitude=2.22&zoomLevel=15', headers=headers)

print(res.json())

