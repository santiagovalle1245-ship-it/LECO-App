import Foundation

// 1. Molde para una Pregunta
struct PreguntaCuento {
    let pregunta: String
    let opciones: [String]
    let respuestaCorrecta: String
}

// 2. Molde principal del Cuento actualizado
struct Cuento: Identifiable {
    let id: Int
    let titulo: String
    let autor: String
    let imagenPortada: String
    let contenido: String
    let preguntas: [PreguntaCuento] // Ahora es una lista de preguntas
}

// 3. Lista de cuentos con 2 preguntas cada uno
let listaDeCuentos: [Cuento] = [
    Cuento(
        id: 1,
        titulo: "La Liebre y la Tortuga",
        autor: "Esopo",
        imagenPortada: "portada_liebre",
        contenido: "Había una vez una liebre muy veloz que se burlaba de una tortuga por su lentitud. '¿Quieres hacer una carrera?', le preguntó la tortuga. La liebre, riendo, aceptó. La carrera empezó y la liebre desapareció de vista. Al ver que tenía mucha ventaja, se detuvo a descansar bajo un árbol y se quedó dormida. La tortuga, pasito a pasito, nunca se detuvo y, cuando la liebre despertó, vio con asombro que la tortuga estaba cruzando la meta. Moraleja: la constancia vence a la rapidez.",
        preguntas: [
            PreguntaCuento(pregunta: "¿Quién ganó la carrera?", opciones: ["La Liebre", "La Tortuga", "El Zorro"], respuestaCorrecta: "La Tortuga"),
            PreguntaCuento(pregunta: "¿Por qué perdió la liebre?", opciones: ["Se quedó dormida", "Se perdió", "Comió mucho"], respuestaCorrecta: "Se quedó dormida")
        ]
    ),
    Cuento(
        id: 2,
        titulo: "El León y el Ratón",
        autor: "Esopo",
        imagenPortada: "portada_leon",
        contenido: "Un pequeño ratón despertó a un león sin querer. El león, furioso, iba a comérselo, pero el ratón le suplicó que lo perdonara, prometiéndole que algún día le devolvería el favor. El león se rió de la idea, pero lo dejó ir. Tiempo después, el león quedó atrapado en una red de cazadores. El ratón escuchó sus rugidos, corrió hacia él y royó las cuerdas con sus pequeños dientes hasta liberarlo. Moraleja: ningún acto de bondad, por pequeño que sea, es en vano.",
        preguntas: [
            PreguntaCuento(pregunta: "¿Qué prometió el ratón?", opciones: ["Traer comida", "Devolver el favor", "Cantar una canción"], respuestaCorrecta: "Devolver el favor"),
            PreguntaCuento(pregunta: "¿Cómo liberó al león?", opciones: ["Royó las cuerdas", "Cortó la red", "Llamó ayuda"], respuestaCorrecta: "Royó las cuerdas")
        ]
    ),
    Cuento(
        id: 3,
        titulo: "Ricitos de Oro",
        autor: "Cuento popular",
        imagenPortada: "portada_ricitos",
        contenido: "Había una vez una niña llamada Ricitos de Oro. Encontró una casa en el bosque y entró. Probó la sopa del tazón grande (muy caliente), la del tazón mediano (muy fría) y la del tazón pequeño (perfecta). Luego, se sentó en la silla pequeña y se rompió. Finalmente, se durmió en la cama pequeña. Los tres osos, que vivían allí, regresaron. '¡Alguien probó mi sopa!', dijo Papá Oso. '¡Alguien durmió en mi cama!', dijo Bebé Oso, y despertó a Ricitos de Oro. La niña se asustó y salió corriendo.",
        preguntas: [
            PreguntaCuento(pregunta: "¿Cuántos osos vivían en la casa?", opciones: ["Dos", "Tres", "Cuatro"], respuestaCorrecta: "Tres"),
            PreguntaCuento(pregunta: "¿Qué sopa estaba perfecta?", opciones: ["La del tazón pequeño", "La del tazón grande", "La fría"], respuestaCorrecta: "La del tazón pequeño")
        ]
    ),
    Cuento(
        id: 4,
        titulo: "El Pastorcito Mentiroso",
        autor: "Esopo",
        imagenPortada: "portada_pastor",
        contenido: "Había un joven pastor que cuidaba sus ovejas. Un día, para divertirse, corrió al pueblo gritando: '¡Viene el lobo!'. La gente del pueblo corrió a ayudarlo, pero solo lo encontraron riendo. El pastor hizo la misma broma al día siguiente. Pero un atardecer, un lobo de verdad apareció. '¡Viene el lobo! ¡Ayuda!'. Pero esta vez, nadie en el pueblo le creyó. Moraleja: Nadie cree a un mentiroso, incluso cuando dice la verdad.",
        preguntas: [
            PreguntaCuento(pregunta: "¿Qué gritaba el pastor?", opciones: ["¡Fuego!", "¡Viene el lobo!", "¡Hola!"], respuestaCorrecta: "¡Viene el lobo!"),
            PreguntaCuento(pregunta: "¿Por qué nadie le creyó al final?", opciones: ["Por mentiroso", "Porque no lo oyeron", "Porque estaba lejos"], respuestaCorrecta: "Por mentiroso")
        ]
    ),
    Cuento(
        id: 5,
        titulo: "El Patito Feo",
        autor: "Hans Christian Andersen",
        imagenPortada: "portada_patito",
        contenido: "Una pata empolló unos huevos, pero uno de los patitos era mucho más grande y gris que los demás. Todos se burlaban de él y lo llamaban 'patito feo'. El patito, triste, huyó y pasó el invierno solo. Cuando llegó la primavera, vio una bandada de hermosas aves blancas nadando en el lago. Al mirarse en el agua, descubrió que él también se había convertido en un hermoso cisne. Moraleja: No importa de dónde vengas, tu valor reside en quién eres.",
        preguntas: [
            PreguntaCuento(pregunta: "¿En qué se convirtió el patito?", opciones: ["En un ganso", "En un cisne", "En un águila"], respuestaCorrecta: "En un cisne"),
            PreguntaCuento(pregunta: "¿Por qué se burlaban de él?", opciones: ["Era diferente", "Era pequeño", "No sabía nadar"], respuestaCorrecta: "Era diferente")
        ]
    ),
    Cuento(
        id: 6,
        titulo: "El Traje Nuevo del Emperador",
        autor: "Hans Christian Andersen",
        imagenPortada: "portada_emperador",
        contenido: "Un emperador vanidoso que amaba la ropa contrató a dos estafadores que prometieron tejerle un traje invisible para los tontos. Los estafadores fingieron tejer, y el emperador, temiendo parecer tonto, fingió ver la tela. Desfiló por la ciudad 'vistiendo' el traje. Toda la gente fingía admirarlo hasta que un niño gritó: '¡Pero si no lleva nada puesto!'. La verdad se reveló, pero el emperador siguió desfilando, avergonzado.",
        preguntas: [
            PreguntaCuento(pregunta: "¿Qué tenía de especial el traje?", opciones: ["Era de oro", "Era invisible", "Volaba"], respuestaCorrecta: "Era invisible"),
            PreguntaCuento(pregunta: "¿Quién dijo la verdad?", opciones: ["Un niño", "El emperador", "Los estafadores"], respuestaCorrecta: "Un niño")
        ]
    ),
    Cuento(
        id: 7,
        titulo: "El Ratón de Campo y Ciudad",
        autor: "Esopo",
        imagenPortada: "portada_ratones",
        contenido: "Un ratón de campo invitó a su primo de la ciudad a cenar y le ofreció cereales y raíces. El ratón de ciudad lo invitó a su vez, mostrándole un festín de quesos y dulces en una despensa. Justo cuando iban a comer, apareció el gato y tuvieron que huir. 'Prefiero mi vida tranquila en el campo', dijo el ratón de campo, 'donde, aunque la comida es simple, no hay peligros'.",
        preguntas: [
            PreguntaCuento(pregunta: "¿Quién apareció en la ciudad?", opciones: ["Un perro", "Un gato", "El dueño"], respuestaCorrecta: "Un gato"),
            PreguntaCuento(pregunta: "¿Qué prefirió el ratón de campo?", opciones: ["La tranquilidad", "El queso", "La ciudad"], respuestaCorrecta: "La tranquilidad")
        ]
    ),
    Cuento(
        id: 8,
        titulo: "La Cigarra y la Hormiga",
        autor: "Esopo",
        imagenPortada: "portada_cigarra",
        contenido: "En verano, la hormiga trabajaba día y noche recolectando comida, mientras la cigarra solo se dedicaba a cantar. '¡Deberías guardar comida!', le decía la hormiga. 'Hay tiempo de sobra', respondía la cigarra. Al llegar el invierno, la cigarra no tenía qué comer y fue a pedirle ayuda a la hormiga. La hormiga le dijo: 'Si cantaste en verano, ahora baila en invierno'. Moraleja: Es necesario trabajar y ser previsor.",
        preguntas: [
            PreguntaCuento(pregunta: "¿Qué hacía la cigarra en verano?", opciones: ["Trabajar", "Cantar", "Dormir"], respuestaCorrecta: "Cantar"),
            PreguntaCuento(pregunta: "¿Quién recolectaba comida?", opciones: ["La hormiga", "La cigarra", "El grillo"], respuestaCorrecta: "La hormiga")
        ]
    ),
    Cuento(
        id: 9,
        titulo: "Pulgarcita",
        autor: "Hans Christian Andersen",
        imagenPortada: "portada_pulgarcita",
        contenido: "Una mujer, deseando tener una hija, plantó una semilla y de ella nació una flor que contenía una niña diminuta del tamaño de un pulgar. Pulgarcita fue raptada por un sapo para que se casara con su hijo, y luego vivió muchas aventuras con ratones, topos y golondrinas. Finalmente, una golondrina la llevó a un país cálido, donde se casó con un príncipe de las flores, tan pequeño como ella.",
        preguntas: [
            PreguntaCuento(pregunta: "¿De qué tamaño era la niña?", opciones: ["Como una mano", "Como un pulgar", "Muy alta"], respuestaCorrecta: "Como un pulgar"),
            PreguntaCuento(pregunta: "¿Con quién se casó al final?", opciones: ["Un príncipe", "Un sapo", "Un topo"], respuestaCorrecta: "Un príncipe")
        ]
    ),
    Cuento(
        id: 10,
        titulo: "Los Tres Cerditos",
        autor: "Cuento popular",
        imagenPortada: "portada_cerditos",
        contenido: "Tres cerditos construyeron sus casas: uno de paja, otro de madera y el tercero de ladrillo. El lobo feroz sopló y derrumbó las casas de paja y madera, obligando a los cerditos a refugiarse con su hermano. Cuando el lobo sopló la casa de ladrillo y no pudo tirarla, intentó entrar por la chimenea. El cerdito más inteligente puso una olla de agua hirviendo y el lobo huyó. Moraleja: El trabajo duro y la planificación dan frutos.",
        preguntas: [
            PreguntaCuento(pregunta: "¿De qué era la casa fuerte?", opciones: ["Paja", "Madera", "Ladrillo"], respuestaCorrecta: "Ladrillo"),
            PreguntaCuento(pregunta: "¿Por dónde entró el lobo?", opciones: ["La puerta", "La chimenea", "La ventana"], respuestaCorrecta: "La chimenea")
        ]
    )
]
