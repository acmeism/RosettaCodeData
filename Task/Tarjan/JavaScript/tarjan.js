class Graph {
    constructor(size) {
        this.adjacencyLists = [];
        this.vertices = [];
        this.index = 0;
        this.stack = [];
        this.numbers = new Map();
        this.lowlinks = new Map();
        this.stronglyConnectedComponents = [];

        for (let i = 0; i < size; i++) {
            this.vertices.push(i);
            this.adjacencyLists.push(new Set());
        }
    }

    addDirectedEdge(from, to) {
        this.adjacencyLists[from].add(to);
    }

    getSCC() {
        for (const vertex of this.vertices) {
            if (!this.numbers.has(vertex)) {
                this.stronglyConnect(vertex);
            }
        }

        return this.stronglyConnectedComponents;
    }

    stronglyConnect(vertex) {
        this.numbers.set(vertex, this.index);
        this.lowlinks.set(vertex, this.index);
        this.index += 1;
        this.stack.push(vertex);

        for (const adjacent of this.adjacencyLists[vertex]) {
            if (!this.numbers.has(adjacent)) {
                this.stronglyConnect(adjacent);
                this.lowlinks.set(vertex, Math.min(this.lowlinks.get(vertex), this.lowlinks.get(adjacent)));
            } else if (this.stack.includes(adjacent)) {
                this.lowlinks.set(vertex, Math.min(this.lowlinks.get(vertex), this.numbers.get(adjacent)));
            }
        }

        if (this.lowlinks.get(vertex) === this.numbers.get(vertex)) {
            const stronglyConnectedComponent = new Set();
            let top;
            do {
                top = this.stack.pop();
                stronglyConnectedComponent.add(top);
            } while (top !== vertex);

            this.stronglyConnectedComponents.push(stronglyConnectedComponent);
        }
    }
}

// Main function equivalent
function main() {
    const graph = new Graph(8);

    graph.addDirectedEdge(0, 1);
    graph.addDirectedEdge(1, 2);
    graph.addDirectedEdge(1, 7);
    graph.addDirectedEdge(2, 3);
    graph.addDirectedEdge(2, 6);
    graph.addDirectedEdge(3, 4);
    graph.addDirectedEdge(4, 2);
    graph.addDirectedEdge(4, 5);
    graph.addDirectedEdge(6, 3);
    graph.addDirectedEdge(6, 5);
    graph.addDirectedEdge(7, 0);
    graph.addDirectedEdge(7, 6);

    console.log("The strongly connected components are: ");
    for (const component of graph.getSCC()) {
        console.log(component);
    }
}

// Run the main function
main();
