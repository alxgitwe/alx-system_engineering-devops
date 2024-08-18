#!/usr/bin/python3
import requests

def number_of_subscribers(subreddit):
    headers = {
        "User-Agent": "0x16. API_advanced-e_kiminza"
    }
    url = f"https://www.reddit.com/r/{subreddit}/about.json"
    response = requests.get(url, headers=headers, allow_redirects=False)

    if response.status_code == 200:
        return response.json().get("data").get("subscribers")
    else:
        return 0
