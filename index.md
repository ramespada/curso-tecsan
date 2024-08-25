---
layout: page
title: Modelado de la calidad del aire
nositetitle: true
---

El objetivo del curso es exponer las bases para la implementación de modelos de calidad del aire especialmente enfocada en los procesos que tienen lugar en el complejo ambiental.

Acá subiremos algo de [material](./material/) para profundizar los temas tratados.

# Programa del curso

<ul>
{% assign clases = site['clases'] | sort: 'date' %}
{% for clase in clases %}
    {% if clase.phony != true %}
      {% if clase.ready %}
        <li>
        <strong>{{ clase.date | date: '%d/%m' }}</strong>:
            <a href="{{site.baseurl}}{{ clase.url }}">{{ clase.title }}</a>
        </li>
        {% else %}
        <li>
        <strong>{{ clase.date | date: '%d/%m' }}</strong>:
            {{ clase.title }} [coming soon]
        </li>
        {% comment %}
        	 <li>  {{ clase.title }} {% if clase.noclass %}[no class]{% endif %}</li> 
        {%endcomment%}
      {% endif %}
    {% endif %}
{% endfor %}
</ul>

<!-- Los video tutoriales estarán disponible [en Youtube](https://www.youtube.com/@ramiroespadaguerrero/playlists). -->

---

<div class="small center">
<p><a href="https://github.com/ramespada/tecsan-capacitacion">Repositorio</a>.</p>
<p>Ramiro A. Espada</p>
<p></p>
</div>
