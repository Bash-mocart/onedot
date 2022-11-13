import requests


if __name__ == '__main__':
    url = 'http://onedot-lb-onedot-app-823327087.ap-southeast-1.elb.amazonaws.com:8080/'
    res_count = {}
    for _ in range(10):
        re = requests.get(url).text
        if re in res_count.keys():
            res_count[re] += 1
        else:
            res_count[re] = 1
    print(res_count)