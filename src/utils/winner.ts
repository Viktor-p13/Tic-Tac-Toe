import { WIN_LINES } from './constants'
import type { BoardState, Player } from '../types/game'

function isWinningLine(board: BoardState, line: readonly number[]): Player | null {
  const [a, b, c] = line
  const first = board[a]
  if (first && first === board[b] && first === board[c]) {
    return first
  }
  return null
}
