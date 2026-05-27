import { useGame } from './hooks/useGame'
import { Board } from './components/Board'
import { GameStatus } from './components/GameStatus'

export default function App() {
  const { state, playMove } = useGame()

  return (
    <main className="app">
      <h1>Tic-Tac-Toe</h1>
      <GameStatus state={state} />
      <Board board={state.board} status={state.status} onCellClick={playMove} />
    </main>
  )
}
