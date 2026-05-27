import type { BoardState, GameStatus } from '../types/game'
import { Cell } from './Cell'

interface BoardProps {
  board: BoardState
  status: GameStatus
  onCellClick: (index: number) => void
}

export function Board({ board, status, onCellClick }: BoardProps) {
  const disabled = status !== 'playing'

  return (
    <div className="board" role="grid" aria-label="Tic-tac-toe board">
      {board.map((value, index) => (
        <Cell
          key={index}
          value={value}
          disabled={disabled || value !== null}
          onClick={() => onCellClick(index)}
        />
      ))}
    </div>
  )
}
