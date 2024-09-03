---
layout: page
title: "Casos de estudio"
permalink: /casos/
phony: true
excerpt: '' # work around a bug
---



<ul>
  {% assign lectures = site['casos'] | sort: 'date' %}
  {% for lecture in lectures %}
    {% if lecture.phony != true %}
      <li>
        <strong>{{ lecture.date | date: '%d/%m' }}</strong>:
        {% if lecture.ready %}
          <a href="{{ site.baseurl }}{{ lecture.url }}">{{ lecture.title }}</a>
        {% if lecture.details %}
          <br>
          ({{ lecture.details }})
        {% endif %}
      </li>
        {% endif %}
    {% endif %}
  {% endfor %}
</ul>

