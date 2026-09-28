import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "有家计划｜珠海流浪猫领养",
  description: "让领养信息更清楚，让每一次决定更认真。浏览珠海待领养猫咪、提交领养申请或发布救助信息。",
  icons: {
    icon: "/favicon.svg",
    shortcut: "/favicon.svg",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="zh-CN">
      <body className="antialiased">{children}</body>
    </html>
  );
}
