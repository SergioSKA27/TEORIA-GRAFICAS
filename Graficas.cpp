#include <bits/stdc++.h>

#define MAXVERTICES = 1000

/*
        Creamos una clase nodo  para facilitar la implementacion,la clase 
    funciona  como  un template por lo que podremos hacer uso de la clase 
    con distintos tipos de datos.
    
    Dicha clase tiene como atributos:

    ID : identicador del nodo(tiene que ser  del mismo tipo  que el  template
    seleccionado), podemos cambiar dicho atributo en cualquier momento.

    Grado del vertice:  De acuerdo al tipo de  grafo  que  estemos utilizando
    podemos  usar el  atributo  'Grado' para  graficas no  dirigidas, y en el 
    caso de que estemos  usando  graficas  dirigidas podemos hacer uso de los
    atributos 'GradoI' y 'GradoE' que  representan el grado interno y externo
    respectivamente. Los grados de los vertices se actualizan automaticamente 
    al añadir nuevos nodos adyacentes.  

    Listas de adyacencia: Las listas de adyacencia  nos aydan a saber en todo
    momento cuales son los nodos que son  adyacentes  al  nodo  actual , cada 
    lista se compone de un vector de punteros a los nodos adyacentes.
    dependiendo del tipo de grafica podemos usar 'ady' para graficas no  dir.
    o 'ady_in'  y 'ady_out' que representan los nodos que llegan y los nodos 
    que salen respectivamente.
*/

template <class t>
class Node
{

public:
    t ID;
    size_t Grado;  //Grado del vertice(graficas no dirigidas)
    size_t GradoI; //Grado interno (digraficas)
    size_t GradoE; //Grado externo (digraficas)
    //Listas de adyacencia para graficas dirigidas y no dirigidas
    std::vector<Node<t> *> ady;     //vertices para graficas no dirigidas
    std::vector<Node<t> *> ady_in;  //vertices para digraficas(lineas que llegan)
    std::vector<Node<t> *> ady_out; //Vertices para digraficas(lineas que salen)
    Node(t id);
    Node<t> &add_ady(Node<t> *ad);     //añadir nodos adyacentes(graficas no dirigidas)
    Node<t> &add_ady_in(Node<t> *ad);  //Añadir nodos (lineas que llegan)
    Node<t> &add_ady_out(Node<t> *ad); //Añadir nodos (lineas que salen)
    ~Node();
};

template <class t>
Node<t>::Node(t id)
{
    this->ID = id;
    this->Grado = 0;
    this->GradoE = 0;
    this->GradoI = 0;
}

template <class t>
Node<t> &Node<t>::add_ady(Node<t> *ad)
{
    ady.push_back(ad);
    return *this;
}

template <class t>
Node<t> &Node<t>::add_ady_in(Node<t> *ad)
{
    ady_in.push_back(ad);
    return *this;
}

template <class t>
Node<t> &Node<t>::add_ady_out(Node<t> *ad)
{
    ady_out.push_back(ad);
    return *this;
}

template <class t>
Node<t>::~Node()
{
}

int main(int argc, char const *argv[])
{
    /* code */
    return 0;
}
