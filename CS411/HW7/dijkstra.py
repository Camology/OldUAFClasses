from collections import defaultdict, deque
import heapq

#Graph class, it has a set of nodes, a defaultdict of edges, and a dictionary of distances
#This is a bidirectional graph so each relation goes both ways.
class Graph:
    def __init__(self):
        self.nodes = set()
        self.edges = defaultdict(list)
        self.distances = {}
    #Add a node to the graph IF it doesn't already exist
    def addNode(self,value):
        if value not in self.nodes:
            self.nodes.add(value)
        else:
            print("Nice try buddy! " +value+ " already exists! Consider yourself smitten "+ u'\u26A1')
    #Add an edge, only if it's not already defined, adds both versions so it's bidirectional
    def addEdge(self, _from, to, distance):
        if _from in self.nodes and to in self.nodes:
            self.edges[_from].append(to)
            self.edges[to].append(_from)
            if (_from,to) not in self.distances:
                self.distances[_from,to] = distance
            if (to,_from) not in self.distances:
                self.distances[to,_from] = distance

#Find all paths from whatever initial point within a graph using Dijkstra's alg.    
def findDijkstra(graph,initial):
    visited = {initial:0}
    path={}
    nodes = list(graph.nodes)

    while nodes: 
        min = None
        for node in nodes:
            if node in visited:
                if min is None: 
                    min = node
                elif visited[node] < visited[min]:
                    min = node 
        if min is None: 
            break

        nodes.remove(min)
        current_weight = visited[min]

        for edge in graph.edges[min]:
            try:
                weight = current_weight + graph.distances[(min, edge)]
            except:
                continue
            if edge not in visited or weight < visited[edge]:
                visited[edge] = weight
                path[edge] = min
    return visited, path

#Find the shortest path between origin and destination
def findShortestPath(graph, origin, destination):
    visited, paths = findDijkstra(graph, origin)
    full_path = deque()
    try:
        _destination = paths[destination]
    except:
        return "No path from "+origin+ " -> "+ destination + " exists"

    while _destination != origin: 
        full_path.appendleft(_destination)
        _destination = paths[_destination]

    full_path.appendleft(origin)
    full_path.append(destination)
    return visited[destination], list(full_path)

#Find the shortest paths from each origin to each destination
def findShortestPaths(graph, origin):
    for node in graph.nodes:
        if (node != origin):
            print(findShortestPath(graph, origin, node))
        else:
             print('Self path, value: 0')

#Fill a graph if you're lazy and don't want to it in the terminal :p
def lazyFill(graph):
    for node in ['A','B','C','D','E','F']:
        graph.addNode(node)
    graph.addEdge('A','B',1)
    graph.addEdge('B','C',2)
    graph.addEdge('C','D',4)
    graph.addEdge('D','E',2)
    graph.addEdge('A','F',3)
    graph.addEdge('F','E',1)
    graph.addEdge('B','D',4)
    

#Basic terminal input, would change this if making an actual application to something nice an web-based.
if __name__ == '__main__':
    graph = Graph()
    print("Enter as many nodes as you would like, if you enter the same node twice the gods will smite you. Type \'Skip!\' to have a graph made for you")
    while True:
        var = input("Single node(Empty input when done):")
        if var == 'Skip!':
            lazyFill(graph)
            break;
        elif not var.strip():
            break;
        else:    
            graph.addNode(var.strip())
    print("Now input your weights, form is like: From, To, Value. Example: A, B, 1" )
    print("Blank inputs to break")
    while True and var != 'Skip!':
        origin = input("Origin:")
        destination = input("Destination:")
        value = input("Value:")
        if not origin or not destination or not value:
            break
        else:
            graph.addEdge(origin, destination, int(value))
            print('edge added')

    for node in graph.nodes:
        print("---------------------------------")
        print("Node: ", node, " paths:")
        findShortestPaths(graph, node)