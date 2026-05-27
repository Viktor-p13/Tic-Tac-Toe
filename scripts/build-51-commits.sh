#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
COMMIT_SH="$ROOT/.git/safe-commit-push.sh"
chmod +x "$COMMIT_SH"

commit() {
  "$COMMIT_SH" "$1"
  echo "OK: $1"
}

# 1
cat > package.json <<'EOF'
{
  "name": "tic-tac-toe",
  "private": true,
  "version": "1.0.0"
}
EOF
commit "chore: initialize package.json"

# 2
node -e "
const fs=require('fs');
const p=JSON.parse(fs.readFileSync('package.json','utf8'));
p.type='module';
fs.writeFileSync('package.json', JSON.stringify(p,null,2)+'\n');
"
commit "chore: set package type to module"

# 3
node -e "
const fs=require('fs');
const p=JSON.parse(fs.readFileSync('package.json','utf8'));
p.dependencies={react:'^19.1.0','react-dom':'^19.1.0'};
fs.writeFileSync('package.json', JSON.stringify(p,null,2)+'\n');
"
commit "chore: add react dependencies"

# 4
node -e "
const fs=require('fs');
const p=JSON.parse(fs.readFileSync('package.json','utf8'));
p.devDependencies={
  '@types/react':'^19.1.2',
  '@types/react-dom':'^19.1.2',
  '@vitejs/plugin-react':'^4.4.1',
  typescript:'~5.8.3',
  vite:'^6.3.5'
};
fs.writeFileSync('package.json', JSON.stringify(p,null,2)+'\n');
"
commit "chore: add vite and typescript dev dependencies"

# 5
node -e "
const fs=require('fs');
const p=JSON.parse(fs.readFileSync('package.json','utf8'));
p.scripts={dev:'vite',build:'tsc -b && vite build',preview:'vite preview'};
fs.writeFileSync('package.json', JSON.stringify(p,null,2)+'\n');
"
commit "chore: add npm scripts"

# 6
cat > tsconfig.json <<'EOF'
{
  "files": [],
  "references": [
    { "path": "./tsconfig.app.json" },
    { "path": "./tsconfig.node.json" }
  ]
}
EOF
commit "chore: add root tsconfig"

# 7
cat > tsconfig.app.json <<'EOF'
{
  "compilerOptions": {
    "tsBuildInfoFile": "./node_modules/.tmp/tsconfig.app.tsbuildinfo",
    "target": "ES2022",
    "useDefineForClassFields": true,
    "lib": ["ES2022", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "verbatimModuleSyntax": true,
    "moduleDetection": "force",
    "noEmit": true,
    "jsx": "react-jsx",
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true,
    "noUncheckedSideEffectImports": true
  },
  "include": ["src"]
}
EOF
commit "chore: add tsconfig for app sources"

# 8
cat > tsconfig.node.json <<'EOF'
{
  "compilerOptions": {
    "tsBuildInfoFile": "./node_modules/.tmp/tsconfig.node.tsbuildinfo",
    "target": "ES2023",
    "lib": ["ES2023"],
    "module": "ESNext",
    "skipLibCheck": true,
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "verbatimModuleSyntax": true,
    "moduleDetection": "force",
    "noEmit": true,
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true,
    "noUncheckedSideEffectImports": true
  },
  "include": ["vite.config.ts"]
}
EOF
commit "chore: add tsconfig for vite config"

# 9
cat > vite.config.ts <<'EOF'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
})
EOF
commit "chore: add vite config with react plugin"

# 10
cat > index.html <<'EOF'
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Tic-Tac-Toe</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
EOF
commit "chore: add index.html entry point"

# 11
cat > .gitignore <<'EOF'
node_modules
dist
.DS_Store
*.local
EOF
commit "chore: add gitignore"

# 12
mkdir -p src
cat > src/vite-env.d.ts <<'EOF'
/// <reference types="vite/client" />
EOF
commit "chore: add vite env types"

# 13
cat > src/index.css <<'EOF'
* {
  box-sizing: border-box;
}
EOF
commit "style: add css reset"

# 14
cat >> src/index.css <<'EOF'

body {
  margin: 0;
  min-height: 100vh;
  font-family: system-ui, -apple-system, Segoe UI, Roboto, sans-serif;
  background: #0f172a;
  color: #e2e8f0;
}
EOF
commit "style: add base body styles"

# 15
cat > src/main.tsx <<'EOF'
import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App.tsx'

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <App />
  </StrictMode>,
)
EOF
commit "feat: add react entry point"

# 16
mkdir -p src/types
cat > src/types/game.ts <<'EOF'
export type Player = 'X' | 'O'
EOF
commit "feat: add Player type"

# 17
cat >> src/types/game.ts <<'EOF'

export type CellValue = Player | null
EOF
commit "feat: add CellValue type"

# 18
cat >> src/types/game.ts <<'EOF'

export type BoardState = CellValue[]
EOF
commit "feat: add BoardState type"

# 19
cat >> src/types/game.ts <<'EOF'

export type GameStatus = 'playing' | 'won' | 'draw'
EOF
commit "feat: add GameStatus type"

# 20
cat >> src/types/game.ts <<'EOF'

export interface GameState {
  board: BoardState
  currentPlayer: Player
  status: GameStatus
  winner: Player | null
}
EOF
commit "feat: add GameState interface"

# 21
mkdir -p src/utils
cat > src/utils/constants.ts <<'EOF'
export const BOARD_SIZE = 3
EOF
commit "feat: add board size constant"

# 22
cat >> src/utils/constants.ts <<'EOF'

export const WIN_LINES = [
  [0, 1, 2],
  [3, 4, 5],
  [6, 7, 8],
  [0, 3, 6],
  [1, 4, 7],
  [2, 5, 8],
  [0, 4, 8],
  [2, 4, 6],
] as const
EOF
commit "feat: add winning line patterns"

# 23
cat > src/utils/board.ts <<'EOF'
import { BOARD_SIZE } from './constants'
import type { BoardState, Player } from '../types/game'

export function createEmptyBoard(): BoardState {
  return Array.from({ length: BOARD_SIZE * BOARD_SIZE }, () => null)
}
EOF
commit "feat: add createEmptyBoard utility"

# 24
cat >> src/utils/board.ts <<'EOF'

export function getOppositePlayer(player: Player): Player {
  return player === 'X' ? 'O' : 'X'
}
EOF
commit "feat: add getOppositePlayer utility"

# 25
cat > src/utils/winner.ts <<'EOF'
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
EOF
commit "feat: add winning line checker"

# 26
cat >> src/utils/winner.ts <<'EOF'

export function getWinner(board: BoardState): Player | null {
  for (const line of WIN_LINES) {
    const winner = isWinningLine(board, line)
    if (winner) return winner
  }
  return null
}
EOF
commit "feat: add getWinner utility"

# 27
cat >> src/utils/winner.ts <<'EOF'

export function isBoardFull(board: BoardState): boolean {
  return board.every((cell) => cell !== null)
}
EOF
commit "feat: add isBoardFull utility"

# 28
cat >> src/utils/winner.ts <<'EOF'

export function isDraw(board: BoardState): boolean {
  return isBoardFull(board) && getWinner(board) === null
}
EOF
commit "feat: add isDraw utility"

# 29
mkdir -p src/hooks
cat > src/hooks/useGame.ts <<'EOF'
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
EOF
commit "feat: scaffold useGame hook"

# 30
cat >> src/hooks/useGame.ts <<'EOF'

export function useGame() {
  const [state, setState] = useState<GameState>(createInitialState)

  return { state, setState }
}
EOF
commit "feat: add game state to useGame hook"

# 31 - replace useGame with full implementation part 1
cat > src/hooks/useGame.ts <<'EOF'
import { useCallback, useState } from 'react'
import type { GameState, Player } from '../types/game'
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
EOF
commit "feat: implement game move and reset logic"

# 32
mkdir -p src/components
cat > src/components/Cell.tsx <<'EOF'
import type { CellValue } from '../types/game'

interface CellProps {
  value: CellValue
}
EOF
commit "feat: add Cell component props"

# 33
cat > src/components/Cell.tsx <<'EOF'
import type { CellValue } from '../types/game'

interface CellProps {
  value: CellValue
  onClick: () => void
  disabled: boolean
}

export function Cell({ value, onClick, disabled }: CellProps) {
  return (
    <button type="button" className="cell" onClick={onClick} disabled={disabled}>
      {value ?? ''}
    </button>
  )
}
EOF
commit "feat: implement Cell component"

# 34
cat > src/components/Board.tsx <<'EOF'
import type { BoardState } from '../types/game'
import { Cell } from './Cell'

interface BoardProps {
  board: BoardState
}
EOF
commit "feat: add Board component props"

# 35
cat > src/components/Board.tsx <<'EOF'
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
EOF
commit "feat: implement Board component"

# 36
cat > src/components/GameStatus.tsx <<'EOF'
import type { GameState } from '../types/game'

interface GameStatusProps {
  state: GameState
}
EOF
commit "feat: add GameStatus component props"

# 37
cat > src/components/GameStatus.tsx <<'EOF'
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
EOF
commit "feat: implement GameStatus component"

# 38
cat > src/components/ScoreBoard.tsx <<'EOF'
interface ScoreBoardProps {
  scores: { X: number; O: number; draws: number }
}
EOF
commit "feat: add ScoreBoard component props"

# 39
cat > src/components/ScoreBoard.tsx <<'EOF'
interface ScoreBoardProps {
  scores: { X: number; O: number; draws: number }
}

export function ScoreBoard({ scores }: ScoreBoardProps) {
  return (
    <div className="scoreboard" aria-label="Scoreboard">
      <span>X: {scores.X}</span>
      <span>Draws: {scores.draws}</span>
      <span>O: {scores.O}</span>
    </div>
  )
}
EOF
commit "feat: implement ScoreBoard component"

# 40
cat > src/components/RestartButton.tsx <<'EOF'
interface RestartButtonProps {
  onRestartRound: () => void
  onResetScores: () => void
}

export function RestartButton({ onRestartRound, onResetScores }: RestartButtonProps) {
  return (
    <div className="actions">
      <button type="button" onClick={onRestartRound}>New round</button>
      <button type="button" className="secondary" onClick={onResetScores}>Reset scores</button>
    </div>
  )
}
EOF
commit "feat: add RestartButton component"

# 41
cat > src/App.tsx <<'EOF'
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
EOF
commit "feat: add initial App layout"

# 42
cat > src/App.tsx <<'EOF'
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
EOF
commit "feat: wire score tracking and controls in App"

# 43
cat > src/App.css <<'EOF'
.app {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 1rem;
  padding: 1.5rem;
}
EOF
commit "style: add app layout styles"

# 44
cat >> src/App.css <<'EOF'

.board {
  display: grid;
  grid-template-columns: repeat(3, 5rem);
  grid-template-rows: repeat(3, 5rem);
  gap: 0.5rem;
}
EOF
commit "style: add board grid layout"

# 45
cat >> src/App.css <<'EOF'

.cell {
  width: 5rem;
  height: 5rem;
  border: 2px solid #334155;
  border-radius: 0.75rem;
  background: #1e293b;
  color: #f8fafc;
  font-size: 2rem;
  font-weight: 700;
  cursor: pointer;
}

.cell:disabled {
  cursor: not-allowed;
  opacity: 0.85;
}
EOF
commit "style: add cell button styles"

# 46
cat >> src/App.css <<'EOF'

.cell:not(:disabled):hover {
  background: #334155;
}

.status {
  margin: 0;
  font-size: 1.1rem;
}

.status-win {
  color: #4ade80;
}

.status-draw {
  color: #fbbf24;
}
EOF
commit "style: add status and hover styles"

# 47
cat >> src/App.css <<'EOF'

.scoreboard {
  display: flex;
  gap: 1.25rem;
  font-weight: 600;
}

.actions {
  display: flex;
  gap: 0.75rem;
}

.actions button {
  border: none;
  border-radius: 0.5rem;
  padding: 0.6rem 1rem;
  background: #2563eb;
  color: white;
  font-weight: 600;
  cursor: pointer;
}

.actions button.secondary {
  background: #475569;
}
EOF
commit "style: add scoreboard and action button styles"

# 48
cat > src/main.tsx <<'EOF'
import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import './App.css'
import App from './App.tsx'

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <App />
  </StrictMode>,
)
EOF
commit "style: import App stylesheet in main entry"

# 49
cat > README.md <<'EOF'
# Tic-Tac-Toe

A simple Tic-Tac-Toe game built with React and TypeScript.

## Features

- 3x3 board with alternating X and O turns
- Win and draw detection
- Score tracking across rounds
- New round and reset scores actions

## Tech stack

- React 19
- TypeScript
- Vite

## Getting started

```bash
npm install
npm run dev
```

Build for production:

```bash
npm run build
```
EOF
commit "docs: update README with usage instructions"

# 50 - fix score double counting with ref
cat > src/App.tsx <<'EOF'
import { useCallback, useEffect, useRef, useState } from 'react'
import { useGame } from './hooks/useGame'
import { Board } from './components/Board'
import { GameStatus } from './components/GameStatus'
import { ScoreBoard } from './components/ScoreBoard'
import { RestartButton } from './components/RestartButton'
import type { Player } from './types/game'

export default function App() {
  const { state, playMove, resetRound } = useGame()
  const [scores, setScores] = useState({ X: 0, O: 0, draws: 0 })
  const lastCountedStatus = useRef<string>('playing|null')

  useEffect(() => {
    const key = `${state.status}|${state.winner ?? 'null'}`
    if (key === lastCountedStatus.current) return
    lastCountedStatus.current = key

    if (state.status === 'won' && state.winner) {
      setScores((prev) => ({ ...prev, [state.winner as Player]: prev[state.winner as Player] + 1 }))
    }
    if (state.status === 'draw') {
      setScores((prev) => ({ ...prev, draws: prev.draws + 1 }))
    }
  }, [state.status, state.winner])

  const resetScores = useCallback(() => {
    setScores({ X: 0, O: 0, draws: 0 })
    lastCountedStatus.current = 'playing|null'
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
EOF
commit "fix: prevent duplicate score updates on re-render"

# 51
cat >> src/App.css <<'EOF'

h1 {
  margin: 0;
  letter-spacing: 0.04em;
}

.actions button:hover {
  filter: brightness(1.08);
}
EOF
commit "style: polish title and button hover feedback"

echo "All 51 commits pushed."
