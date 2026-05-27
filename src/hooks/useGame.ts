import { useCallback, useState } from 'react'
import type { BoardState, GameState, Player } from '../types/game'
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

  return { state, setState }
}
