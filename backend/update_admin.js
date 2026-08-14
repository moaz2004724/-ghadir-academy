import { PrismaClient } from '@prisma/client';
import dotenv from 'dotenv';
import bcrypt from 'bcryptjs';

dotenv.config();

const prisma = new PrismaClient();

async function updateAdminCredentials() {
  const newEmail = 'admin@ghadirsports.sa';
  const newPassword = 'Ghadir@2026!';
  const hashedPassword = bcrypt.hashSync(newPassword, 10);

  console.log('Updating Admin credentials in PostgreSQL database...');

  try {
    // 1. Update all ADMIN and SUPER_ADMIN user passwords to hashedPassword
    const updatedCount = await prisma.user.updateMany({
      where: {
        role: { in: ['ADMIN', 'SUPER_ADMIN'] }
      },
      data: {
        password: hashedPassword
      }
    });

    console.log(`Updated passwords for ${updatedCount.count} admin user(s).`);

    // 2. Delete any old admin test users with obsolete emails if needed or update main admin user
    const existingMainAdmin = await prisma.user.findFirst({
      where: {
        OR: [
          { email: newEmail },
          { id: 'admin' },
          { id: 'royal-admin-id' },
          { id: 'ghadir-admin-id' }
        ]
      }
    });

    if (existingMainAdmin) {
      await prisma.user.update({
        where: { id: existingMainAdmin.id },
        data: {
          email: newEmail,
          password: hashedPassword,
          name: 'مدير الأكاديمية'
        }
      });
    } else {
      await prisma.user.create({
        data: {
          id: 'admin',
          email: newEmail,
          password: hashedPassword,
          role: 'ADMIN',
          name: 'مدير الأكاديمية'
        }
      });
    }

    // 3. Make sure any other admin user records also have updated password
    await prisma.user.updateMany({
      where: {
        role: 'ADMIN'
      },
      data: {
        password: hashedPassword
      }
    });

    console.log('Admin user updated successfully to email:', newEmail);
  } catch (error) {
    console.error('Failed to update admin credentials:', error);
    process.exit(1);
  } finally {
    await prisma.$disconnect();
  }
}

updateAdminCredentials();
