---
layout: page
title: "Casos de estudio"
permalink: /casos/
phony: true
excerpt: '' # work around a bug
---

Casos de aplicacicón de fuentes emisoras dentro del predio.

<ul>
   {% assign lectures = site['casos'] | sort: 'date' %}
   {% for lecture in lectures %}
       {% if lecture.ready %}
       {% unless lecture.view %}
       <li> <a href="{{ site.baseurl }}{{ lecture.url }}">{{ lecture.title }}</a>: {{ lecture.description}} <br> </li>
       {% endunless %}
       {% endif %}
   {% endfor %}
</ul>


Casos de aplicación utilizado AERMOD View:

<ul>
   {% assign lectures = site['casos'] | sort: 'date' %}
   {% for lecture in lectures %}
       {% if lecture.ready %}
       {% if lecture.view %}
       <li> <a href="{{ site.baseurl }}{{ lecture.url }}">{{ lecture.title }}</a>: {{ lecture.description}} <br> </li>
       {% endif %}
       {% endif %}
   {% endfor %}
</ul>
