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

export function getWinner(board: BoardState): Player | null {
  for (const line of WIN_LINES) {
    const winner = isWinningLine(board, line)
    if (winner) return winner
  }
  return null
}

export function isBoardFull(board: BoardState): boolean {
  return board.every((cell) => cell !== null)
}

export function isDraw(board: BoardState): boolean {
  return isBoardFull(board) && getWinner(board) === null
}
