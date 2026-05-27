import { useCallback, useEffect, useState } from 'react'
import { useGame } from './hooks/useGame'
import { Board } from './components/Board'
import { GameStatus } from './components/GameStatus'
import { ScoreBoard } from './components/ScoreBoard'
import { RestartButton } from './components/RestartButton'
import type { Player } from './types/game'

export default function App() {
  const { state, playMove, resetRound } = useGame()
  const [scores, setScores] = useState({ X: 0, O: 0, draws: 0 })

  useEffect(() => {
    if (state.status === 'won' && state.winner) {
      setScores((prev) => ({ ...prev, [state.winner as Player]: prev[state.winner as Player] + 1 }))
    }
    if (state.status === 'draw') {
      setScores((prev) => ({ ...prev, draws: prev.draws + 1 }))
    }
  }, [state.status, state.winner])

  const resetScores = useCallback(() => {
    setScores({ X: 0, O: 0, draws: 0 })
    resetRound()
  }, [resetRound])

  return (
    <main className="app">
      <h1>Tic-Tac-Toe</h1>
      <ScoreBoard scores={scores} />
      <GameStatus state={state} />
      <Board board={state.board} status={state.status} onCellClick={playMove} />
      <RestartButton onRestartRound={resetRound} onResetScores={resetScores} />
    </main>
  )
}
