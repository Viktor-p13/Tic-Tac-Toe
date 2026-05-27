import { useCallback, useState } from 'react'
import type { GameState } from '../types/game'
import { createEmptyBoard, getOppositePlayer } from '../utils/board'
import { getWinner, isDraw } from '../utils/winner'

function createInitialState(): GameState {
  return {
    board: createEmptyBoard(),
    currentPlayer: 'X',
    status: 'playing',
    winner: null,
  }
}

export function useGame() {
  const [state, setState] = useState<GameState>(createInitialState)

  const playMove = useCallback((index: number) => {
    setState((prev) => {
      if (prev.status !== 'playing' || prev.board[index] !== null) {
        return prev
      }

      const board = [...prev.board]
      board[index] = prev.currentPlayer
      const winner = getWinner(board)

      if (winner) {
        return { board, currentPlayer: prev.currentPlayer, status: 'won', winner }
      }

      if (isDraw(board)) {
        return { board, currentPlayer: prev.currentPlayer, status: 'draw', winner: null }
      }

      return {
        board,
        currentPlayer: getOppositePlayer(prev.currentPlayer),
        status: 'playing',
        winner: null,
      }
    })
  }, [])

  const resetRound = useCallback(() => {
    setState(createInitialState())
  }, [])

  return { state, playMove, resetRound }
}
