import requests

def send_http_request(url):
    try:
        response = requests.get(url)
        
        # 打印响应状态码
        print("Status Code:", response.status_code)
        
        # 打印响应内容
        print("Response:")
        print(response.text)
        
    except requests.exceptions.RequestException as e:
        print("Error:", e)

if __name__ == "__main__":
    # 指定要请求的 URL
    target_url = "http://10.10.10.2:80"
    
    # 发送 HTTP 请求并打印响应
    send_http_request(target_url)

