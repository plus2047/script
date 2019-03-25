#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
translate markdown from mweb app library to zhihu.

copy markdown page from mweb app library, 
convert it into html for zhihu & handle math formular,
copy it into system pasteboard.
"""

from __future__ import print_function
from __future__ import division
from __future__ import with_statement

from richxerox import copy, paste  # for read / write pasteboard
from mistune import markdown
import re
from urllib.parse import quote

mweb_path_template = "/Users/plus/Library/Mobile Documents/iCloud~com~coderforart~iOS~MWeb/Documents" \
                     "/mweb_documents_library/docs/%s.md"
zhihu_template = """<img src="https://www.zhihu.com/equation?tex=%s" alt="%s" class="ee_img tr_noresize" eeimg="1">"""

# get file link from pasteboard
# file link seems like: [统计学习基础 第 01 章 统计学习方法概论](mweblib://15232797021591)
file_link = paste()
file_id = None
try:
    file_id = file_link.split("//")[1][:-1]
    print("File id is: %s" % file_id)
except (AttributeError, IndexError):
    print("Text in pasteboard is not a MWeb link.")
    exit(1)

file_path = mweb_path_template % file_id
print("File path is: %s" % file_path)

md = None
try:
    with open(file_path) as f:
        md = f.read()
except IOError:
    print("Cannot open md file.")
    exit(1)


def tex_handler(match):
    match = match.group()
    print("match LaTeX: %s" % match)
    multi_line = False
    if match[:2] == "$$":
        match = match[2:-2]
        multi_line = True
    else:
        match = match[1:-1]
    res = zhihu_template % (quote(match), match)
    if multi_line:
        return '<p>' + res + '</p>'
    else:
        return res


md = re.sub(re.compile(r'\$\$[\s\S]*?\$\$', re.MULTILINE), tex_handler, md)
md = re.sub(re.compile(r'\$[\s\S]*?\$', re.MULTILINE), tex_handler, md)

html = markdown(md)
html = re.sub('&lt;', '<', html)
html = re.sub('&gt;', '>', html)

copy(html=html)
print("All Finished. HTML code have been save to system pasteboard.")
