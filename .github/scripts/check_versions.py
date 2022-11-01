import os

from github import Github
token = os.environ.get('GITHUB_TOKEN',False)
token_enc = token
if not token:
    token = open('.accesstoken').read()
    token_enc = token.encode('ascii')
g = Github(token)
nist = g.get_repo(os.environ.get('SOURCE_REPO', "usnistgov/oscal-cli"))
nist_tags = nist.get_tags()
releases = {t.name:t.commit.sha for t in list(nist_tags)}
target_name = max(releases.keys())
target_hash = releases.get(target_name)

import requests, base64, json
headers = {"Authorization": f"Bearer {base64.b64encode(token_enc).decode('ascii')}"}
repo = os.environ.get('TARGET_REPO', "shrgroup/oscal-cli")
tags = requests.get(f'https://ghcr.io/v2/{repo}/tags/list', headers=headers).json().get('tags')
tags = [t for t in tags if not t.endswith('.sig')]

if target_hash not in tags:
    output=dict(name=target_name, hash=target_hash)
else:
    output = {}
# with open(os.environ.get('TARGET_REPO', 'tobuild.json'), 'w') as f:
#     f.write(f"versions=\"{json.dumps(output)}\"")
print(f"::set-output name=versions::{json.dumps(output)}")
