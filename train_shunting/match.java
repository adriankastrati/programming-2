import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.util.ArrayList;
/**
 * steg 2. Änvänder mig av exempelkoden bipred.java
 * koden ska lösa flödesproblemet. Ska läsas från standard input och skriva output till standard output. 
 */
import java.util.Iterator;
import java.util.List;

public class matchingWorking {

 //testafall 
 /**
 java flows < testfall/bfstest.indata
 ex.indata är exemplet från labb instruktionen för indata och utdata av flödesmatchningen
  */

  int X;
  int Y;
  int e;
  Kattio io;
//globala variabler
  int V; // vertex, antalet hörn
  int S; //source vertex, där flödet börjar 
  int T; // sink, där flödet avslutas
  int E; // edges, antal kanter
  int FlowMax; // det maximala flödet som är möjligt från S till T
  ArrayList<ArrayList<Integer>> edges; //arraylista som representerar grafen
  int[][] c; // Finns med i Ford - fulkersons algortimen som Kapaciteten från u till v, c[u,v]
  int[][] f; //Finns med i Ford - fulkersons algortimen som flödet, flödetsmatrisen, f[u,v] := 0 f[v,u] := 0.  
  int[][] cf; //Finns med i Ford - fulkersons algortimen som, restkapaciteten cf[u,v]:=c[u,v]; cf[v,u]:=c[v,u]. 
  int[] p; // path(stig) som kallas för p 

    void readFlows(){
    //Läser antal hörn och kanter, source och sink från input
    V = io.getInt(); 
    S = io.getInt();
    T = io.getInt();
    E = io.getInt();

    //initerar edges till en arraylista. Denna lista används för att lagra närliggande listor med hörn.
    // Loop som körs V+1 gånger ( +1 används för att få rätt indexering/ börja på 1)
    // I loopen initierar en tom arraylista för varje vertex. kant lista läggs till för varje iteration 
    edges = new ArrayList<>();
    for(int j = 0; j < V+1; j++){
      edges.add(new ArrayList<Integer>());
    }

    //fyller kapacitetsmatrisen med givna värderna 
    c = new int[V+1][V+1];  //Kapacitetmatrisen sätts med dimensionerna v+1 som då är hörn med indexering som börjar med 1 
    // En loop som körs E gånger, antalet kanter. I loopen läses heltal a från inputet (reps. satrtpunkt för en kant)
    // b som reps slutpunkten för kanten och k som reps. kapaciteten för kanten mellan hörnen a och b
    for(int i = 0; i < E; i++){
      int a = io.getInt();
      int b = io.getInt();
      int k = io.getInt();
      //säkerställler att grafen är oriktad -> kollar om en kant finns i båda riktininharna innan den läggs till i listan. ////BEHÖVS DETTTAAAAAA!!!!!!!
      //Kollar om kanten b redan finns i listan för a. Om den inte gör det läggs b till i listan över a
      if(!edges.get(a).contains(b)){
        edges.get(a).add(b);
      }
      //kollar om kanten a redan finns i listan för b, om inte läggs a till i listan över a
      if(!edges.get(b).contains(a)) {
        edges.get(b).add(a);
      }
      //Kapaciteten för kanten från hörn a till b sätts till k. 
      c[a][b] = 1;
    }
  }

  // Tar hjälp av pseudokoden av algoritmen 
  /**
   * for varje kant (u,v) i grafen do 
    f[u,v]:=0; f[v,u]:=0 
    cf[u,v]:=c[u,v]; cf[v,u]:=c[v,u] 
   */
  /**
   * Den yttre slingan löper från vertex 1 till V (inklusive). Denna loop cyklar genom varje hörn i grafen.
Den inre slingan (för(Integer j : edges.get(i))) itererar över varje angränsande vertex j i vertex i.
För varje par (i, j) ställer den in den initiala restkapaciteten i matrisen cf att vara densamma som de ursprungliga kapaciteterna i matris c.
   */
  void edmondsKarp() {
    f = new int[V + 1][V + 1];
    cf = new int[V + 1][V + 1];
    for (int i = 1; i <= V; i++) {
        for (Integer j : edges.get(i)) {
            cf[i][j] = c[i][j];
            cf[j][i] = c[j][i];
        }
    }

    FlowMax = 0;
    while (BFS_algoritm()) {
        int pathFlow = Integer.MAX_VALUE;
        int curVertex = T;
        while (curVertex != S) {
            int prevVertex = p[curVertex];
            pathFlow = Math.min(pathFlow, cf[prevVertex][curVertex]);
            curVertex = prevVertex;
        }

        curVertex = T;
        while (curVertex != S) {
            int prevVertex = p[curVertex];
            cf[prevVertex][curVertex] -= pathFlow;
            cf[curVertex][prevVertex] += pathFlow;
            f[prevVertex][curVertex] += pathFlow;
            f[curVertex][prevVertex] -= pathFlow;
            curVertex = prevVertex;
        }

        FlowMax += pathFlow;
    }
  }
  

  //baserad på föreläsningen fyras psudokod av BFS algoritmen + yourbasic.org
  boolean BFS_algoritm() {
    boolean[] visited = new boolean[V + 1]; // en array för att spåra om en vertex har besökts för att undivka återbesök.
    p = new int[V + 1];//array för att spara p som träffas i BFS
    ArrayList<Integer> list = new ArrayList<>();
    list.add(S);//lägg till s i listan.
    visited[S] = true; // markera S som besökt. 
    int a = 0;

    // om listan inte är tom. 
    while (list.size() !=0) {
        a = list.remove(0);  // ta bort första elementet från listan
        //Det aktuella hörnet i, itererara över dess grannar för att upptäcka obesökta hönr med positiv restkapacitiet.
        for (int j = 0; j < edges.get(a).size(); j++) {
            int n = edges.get(a).get(j);//identifera den jte granne till i.
            //Om kanten till granne till har positiv restkapacitet och inte är besökt, då
            if (cf[a][n] > 0 && !visited[n]) {
                list.add(n);  // läggs n till a listan
                visited[n] = true;// markera den som besökt. 
                p[n] = a; //sätt p[n] till a och iterera processen tills n = sink
                //om n är T,sink så retuneras visited[T] true och indikerar att augumenting path har hittats 
                if (n == T) {
                    return visited[T];
                }
            }
        }
    }
    //Om BFS slutförs utan att nå T, retunerar den om T någonson besökts 
    return visited[T];
  }

  void output(){
    io.println(X +" "+Y);// antalet hörn printas ut,
    //io.println(FlowMax); //printar ut maxiumum flow
    int edgeCount = 0;//edge counter

    for(int i = 1+1; i <= V-1; i++){//itererar över alla hörn
      for(Integer j : edges.get(i)){//itererar över varje granne j av vertex i.
        if(f[i][j] > 0 && j != X+Y+2 && i != 1){ //kollar om flödet från vertex i till vertex j är positivt
          edgeCount++; // ökar antalet edges
        }
      }
    }
    io.println(edgeCount);//printar en rad med ett heltal som anger antlet kanter.
    for(int k = 2; k <= V-1; k++){//itererar över alla hörn
      for(Integer l : edges.get(k)){//itererar över varje granne i till vertex k
        if(f[k][l] > 0 && l != X+Y+2){//kollar om flödet från vertex k till vertex i är poisitivt
          io.println((k-1) + " " + (l-1) + " " + 1 ); //printa ut talvärderna för varje matchning.
        }
      }
    }
  }



    String getFlow(Kattio io) {
        // Läs antal hörn och kanter
        this.X = io.getInt();
        this.Y = io.getInt();
        this.e = io.getInt();

        int[][] adjMatrix = new int[X + Y + 2][X + Y + 2];
        int source = 0;
        int sink = X + Y + 1;

        // Läs in kanterna
        for (int i = 0; i < e; i++) {
            int from = io.getInt();
            int to = io.getInt();
                    adjMatrix[from][to] = 1;

        }

        // Lägg till källa och sänk som första och sista hörn
        // Nya kanter mellan varje hörn i X och källa
        for (int i = 1; i < X + 1; i++) {
            adjMatrix[source][i] = 1;
        }
        for (int i = X + 1; i < sink; i++) {
            adjMatrix[i][sink] = 1;
        }

        StringBuilder sb = new StringBuilder();
        sb.append(Y + X + 2 + "\n");
        sb.append(0 + 1 + " " + (Y + X + 1 + 1) + "\n");

        sb.append(e + X + Y + "\n");
        for (int i = 0; i < X + Y + 2; i++) {
            for (int j = 0; j < X + Y + 2; j++) {
                int edge = adjMatrix[i][j];
                if (edge != 0) {
                    sb.append(i + 1 + " " + (j + 1) + " " + edge + "\n");
                }
            }
        }
        return sb.toString();
    }


  

  

  //liknande kod som från exemplet, ändrar bara vilka metoder som ska bli kallade
   matchingWorking(){
    io = new Kattio(System.in, System.out);

    String flowGraphString = getFlow(io);
    io.println(flowGraphString);
      System.err.println("Skickade iväg flödesgrafen");

    io.flush();

    io = new Kattio(new ByteArrayInputStream(flowGraphString.getBytes()), System.out);
    
    readFlows();
    edmondsKarp();
    output();
    io.close();
  }

  //liknande kod som från exemplet
  public static void main(String[] args) {
    new matchingWorking();
  }
   
}