import type { GameState } from '../types/game'

interface GameStatusProps {
  state: GameState
}

export function GameStatus({ state }: GameStatusProps) {
  if (state.status === 'won' && state.winner) {
    return <p className="status status-win">Player {state.winner} wins!</p>
  }

  if (state.status === 'draw') {
    return <p className="status status-draw">It is a draw.</p>
  }

  return <p className="status">Current turn: {state.currentPlayer}</p>
}
