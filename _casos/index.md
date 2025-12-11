---
layout: page
title: "Casos de estudio"
permalink: /casos/
phony: true
excerpt: '' # work around a bug
---



**AERMOD View**:

Casos de aplicacicón de fuentes emisoras dentro del predio.
<ul>
   {% assign lectures = site['casos'] | sort: 'date' %}
   {% for lecture in lectures %}
       {% if lecture.ready && lecture.view %}
       <li> <a href="{{ site.baseurl }}{{ lecture.url }}">{{ lecture.title }}</a>: {{ lecture.description}} <br> </li>
       {% endif %}
   {% endfor %}
</ul>

---

Casos de aplicacicón de fuentes emisoras dentro del predio.

<ul>
   {% assign lectures = site['casos'] | sort: 'date' %}
   {% for lecture in lectures %}
       {% if lecture.ready %}
       <li> <a href="{{ site.baseurl }}{{ lecture.url }}">{{ lecture.title }}</a>: {{ lecture.description}} <br> </li>
       {% endif %}
   {% endfor %}
</ul>

