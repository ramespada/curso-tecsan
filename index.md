---
layout: page
title: Modelado de la calidad del aire
nositetitle: true
---

El objetivo del curso es exponer las bases para la implementación de modelos de calidad del aire especialmente enfocada en los procesos que tienen lugar en el complejo ambiental.

Acá subiremos algo de [material](./material/) para profundizar los temas tratados.

## Unidades Teóricas:

- **Unidad 1**: Introducción y Nociones de meteorología de capa límite.
- **Unidad 2**: Modelos gaussianos y Fundamentos de AERMOD.
- **Unidad 3**: Emisiones.

## Unidades prácticas:
- **Unidad 1**: Preparación de datos y pre-procesamiento.
- **Unidad 2**: Ejecución de AERMOD.
- **Unidad 3**: Post-procesamiento.

## Cronograma

| Fecha | Hora   | Unidad                             |
|-------|--------|------------------------------------|
| 02/11 | Mañana | Introducción y Meteorología        |
|       | Tarde  | Preparación de corrida             |
| 03/11 | Mañana | Fundamentos de AERMOD              |
|       | Tarde  | Ejecucción de AERMOD               |
| 04/11 | Mañana | Emisiones: estimación y reducción. |
|       | Tarde  | Post-procesamiento                 |


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
<p>Consultora Oeste</p>
</div>
