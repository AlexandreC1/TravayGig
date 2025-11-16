import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'KonbitWorks - Travay Gig pou Ayisyen',
  description: 'Marketplace for gig work serving the Haitian community. Find and post local jobs easily.',
  keywords: 'Haiti, jobs, gigs, marketplace, work, Ayiti, travay',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body className={inter.className}>{children}</body>
    </html>
  )
}
