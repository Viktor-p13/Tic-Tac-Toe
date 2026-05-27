import { BOARD_SIZE } from './constants'
import type { BoardState, Player } from '../types/game'

export function createEmptyBoard(): BoardState {
  return Array.from({ length: BOARD_SIZE * BOARD_SIZE }, () => null)
}
