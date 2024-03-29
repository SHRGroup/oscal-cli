import os

from github import Github
token = os.environ.get('GITHUB_TOKEN',False)
if not token:
    token = open('.accesstoken').read()
token_enc = token.encode('ascii')
g = Github(token)
nist = g.get_repo(os.environ.get('SOURCE_REPO', "usnistgov/oscal-cli"))
nist_tags = nist.get_tags()
releases = {t.name:t.commit.sha for t in list(nist_tags)}
print(f"upstream has: {releases}")
target_name = max(releases.keys())
print(f"Latest is: {target_name}")
target_hash = releases.get(target_name)

import requests, base64
headers = {"Authorization": f"Bearer {base64.b64encode(token_enc).decode('ascii')}"}
repo = os.environ.get('TARGET_REPO', "shrgroup/oscal-cli")
tags = requests.get(f'https://ghcr.io/v2/{repo}/tags/list', headers=headers).json().get('tags')
tags = [t for t in tags if not t.endswith('.sig')]
print(f"already built: {tags}")
tobuild = target_hash not in tags
print(f"{tobuild} you need to build {target_name}->{target_hash}")
output_file = os.environ.get('GITHUB_OUTPUT', 'tobuild.json')
with open(output_file, 'a') as f:
    f.write(f"build={tobuild}\n")
    f.write(f"target_name={target_name.replace('v','')}\n")
    f.write(f"target_hash={target_hash}\n")
print(f"wrote to {output_file}")
print(open(output_file).read())
